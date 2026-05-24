import 'dart:async';
import 'dart:convert';
import 'dart:math' show sqrt;

import 'package:minata/core/configs/env.dart';
import 'package:minata/core/enums/voice_session_enum.dart';
import 'package:minata/core/network/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VoiceStreamService {
  /// JWT access token — passed in at construction time by the repository/DI.
  /// Appended as ?token=<jwt> on the WebSocket URL because WS connections
  /// cannot carry an Authorization header on mobile platforms.
  final String token;

  VoiceStreamService({required this.token});

  final AudioRecorder _recorder = AudioRecorder();

  WebSocketChannel? _channel;
  StreamSubscription? _socketSubscription;
  StreamSubscription? _audioSubscription;

  // ── Text (server messages) ─────────────────────────────────────────────────
  // Emits raw JSON strings — the cubit is responsible for parsing.
  final StreamController<String> _textController =
      StreamController<String>.broadcast();

  Stream<String> get textStream => _textController.stream;

  // ── Amplitude (waveform visualiser) ───────────────────────────────────────
  // Derived from raw PCM chunks — works on both emulator and real device.
  // getAmplitude() returns -Infinity on Android emulators, so we compute
  // RMS amplitude directly from the PCM16 audio data instead.
  final StreamController<double> _amplitudeController =
      StreamController<double>.broadcast();

  Stream<double> get amplitudeStream => _amplitudeController.stream;

  // ── WebSocket ──────────────────────────────────────────────────────────────

  Future<void> _initWebSocket() async {
    // Append token as query param — the BE wsAuthGuard reads request.query.token
    final uri = Uri.parse('${Env.webSocketUrl}${ApiEndpoints.voiceStream}')
        .replace(queryParameters: {'token': token});

    _channel = WebSocketChannel.connect(uri);

    // FIX 1: Wait for the WS handshake to fully complete before proceeding.
    // Without this, START_SESSION and audio chunks can be sent before the
    // server has finished the HTTP → WS upgrade, causing the server to drop
    // them or process them out of order.
    await _channel!.ready;

    _socketSubscription = _channel!.stream.listen(
      (event) {
        if (event is String && !_textController.isClosed) {
          _textController.add(event);
        }
      },
      onError: (error) {
        debugPrint('Socket error: $error');
        if (!_textController.isClosed) {
          _textController.add(jsonEncode({
            'type': 'ERROR',
            'payload': {'message': error.toString(), 'code': 'SOCKET_ERROR'},
          }));
        }
      },
      onDone: () => debugPrint('Socket closed'),
      cancelOnError: true,
    );
  }

  // ── Audio capture ──────────────────────────────────────────────────────────

  Future<void> _startAudioStreaming() async {
    final audioStream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits, // linear16 — matches Deepgram config
        sampleRate: 16000,
        numChannels: 1,
      ),
    );

    _audioSubscription = audioStream.listen(
      (chunk) {
        // 1. Forward raw PCM to the backend via WebSocket
        _channel?.sink.add(chunk);

        // 2. Derive amplitude from the same chunk for the waveform visualiser.
        //    This works on emulators AND real devices — no getAmplitude() needed.
        _emitAmplitudeFromPcm(chunk);
      },
      onError: (error) => debugPrint('Audio stream error: $error'),
      // FIX 2: Detect when the mic stream closes unexpectedly (silent failure
      // on some Android versions). Without this handler the subscription just
      // ends with no log output and no audio ever reaches Deepgram again,
      // causing the "No speech detected" error.
      onDone: () {
        debugPrint(
          'WARNING: Audio stream ended unexpectedly — mic may have been '
          'interrupted by the OS or a hardware event.',
        );
        // Emit an error to the text stream so the cubit can surface it in the UI.
        if (!_textController.isClosed) {
          _textController.add(jsonEncode({
            'type': 'ERROR',
            'payload': {
              'message': 'Microphone stream closed unexpectedly',
              'code': 'MIC_STREAM_ENDED',
            },
          }));
        }
      },
    );
  }

  // ── PCM amplitude ──────────────────────────────────────────────────────────

  /// Computes RMS amplitude from a raw PCM16 little-endian chunk and emits
  /// a normalised value in [0.0, 1.0] to the amplitude stream.
  ///
  /// PCM16 = 2 bytes per sample, little-endian, signed (-32768 to 32767).
  /// RMS (root mean square) gives a perceptually accurate loudness reading.
  void _emitAmplitudeFromPcm(List<int> chunk) {
    if (chunk.length < 2 || _amplitudeController.isClosed) return;

    double sum = 0;
    int sampleCount = 0;

    for (int i = 0; i + 1 < chunk.length; i += 2) {
      // Reconstruct 16-bit signed sample from two little-endian bytes
      int sample = (chunk[i + 1] << 8) | chunk[i];
      if (sample > 32767) sample -= 65536; // convert to signed
      sum += sample * sample;
      sampleCount++;
    }

    if (sampleCount == 0) return;

    final rms = sqrt(sum / sampleCount);

    // Normalise: max possible RMS for PCM16 is 32768
    final normalised = (rms / 32768.0).clamp(0.0, 1.0);
    _amplitudeController.add(normalised);
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  Future<void> start() async {
    // FIX 3: Correct startup sequence.
    //
    // OLD (broken):
    //   1. connect socket  ← handshake not awaited
    //   2. send START_SESSION  ← fires before server is ready
    //   3. start mic
    //
    // NEW (fixed):
    //   1. connect socket + await handshake  ← server is fully ready
    //   2. start mic  ← mic warms up while we send the control message
    //   3. send START_SESSION  ← server creates session AFTER mic is live
    //
    // Sending START_SESSION last ensures the server session is created only
    // once audio is already flowing, so no chunks are sent before the session
    // exists and none are dropped with "Audio received before START_SESSION".
    await _initWebSocket();
    await _startAudioStreaming();
    _sendControl(VoiceSessionEnum.startSession.value);
  }

  Future<void> stop() async {
    // 1. Tell BE to finalise (flushes Deepgram buffer → LLM extraction).
    _sendControl(VoiceSessionEnum.endSession.value);

    // 2. Stop mic capture — BE no longer needs audio.
    await _audioSubscription?.cancel();
    _audioSubscription = null;
    await _recorder.stop();

    // 3. Do NOT close the socket — BE will still send
    //    PROCESSING → EXPENSES_SAVED / ERROR.
    //    The cubit closes it after receiving a terminal event.
  }

  void _sendControl(String type) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode({'type': type}));
    }
  }

  Future<void> closeSocket() async {
    await _socketSubscription?.cancel();
    _socketSubscription = null;
    await _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    _textController.close();
    _amplitudeController.close();
  }
}
