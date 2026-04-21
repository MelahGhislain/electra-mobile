import 'dart:async';
import 'dart:convert';

import 'package:electra/core/configs/env.dart';
import 'package:electra/core/enums/voice_session_enum.dart';
import 'package:electra/core/network/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VoiceStreamService {
  final AudioRecorder _recorder = AudioRecorder();

  WebSocketChannel? _channel;
  StreamSubscription? _socketSubscription;
  StreamSubscription? _audioSubscription;

  final StreamController<String> _textController =
      StreamController<String>.broadcast();

  Stream<String> get textStream => _textController.stream;

  Future<void> _initWebSocket() async {
    _channel = WebSocketChannel.connect(
      Uri.parse('${Env.webSocketUrl}${ApiEndpoints.voiceStream}'),
    );

    if (_channel == null) return;

    _socketSubscription = _channel!.stream.listen(
      (event) {
        _handleSocketEvent(event);
      },
      onError: (error) {
        debugPrint('Socket error: $error');
      },
      onDone: () {
        debugPrint('Socket closed');
      },
      cancelOnError: true,
    );
  }

  void _handleSocketEvent(dynamic event) {
    try {
      final data = jsonDecode(event as String);

      final type = data['type'];
      final text = data['text'];

      if ((type == 'partial' || type == 'final') && text != null) {
        _textController.add(text);
      }
    } catch (e) {
      debugPrint('Socket parse error: $e');
    }
  }

  Future<void> _startAudioStreaming() async {
    final audioStream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 16000,
        numChannels: 1,
      ),
    );

    _audioSubscription = audioStream.listen(
      (chunk) {
        _channel?.sink.add(chunk);
      },
      onError: (error) {
        debugPrint('Audio error: $error');
      },
    );
  }

  Future<void> start() async {
    await _initWebSocket();
    await _startSession();
    await _startAudioStreaming();
  }

  Future<void> _startSession() async {
    _channel?.sink.add(
      jsonEncode({"type": VoiceSessionEnum.startSession.value}),
    );
  }

  Future<void> _stopSession() async {
    _channel?.sink.add(jsonEncode({"type": VoiceSessionEnum.endSession.value}));
  }

  Future<void> stop() async {
    await _stopSession();

    await _audioSubscription?.cancel();
    await _recorder.stop();
    await _socketSubscription?.cancel();
    await _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    _textController.close();
  }
}
