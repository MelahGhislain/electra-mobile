import 'dart:async';
import 'dart:convert';

import 'package:minata/domain/repository/voice/voice_repository.dart';
import 'package:minata/domain/usecases/voice/start_voice_stream.dart';
import 'package:minata/domain/usecases/voice/stop_voice_stream.dart';
import 'package:minata/domain/usecases/voice/listen_voice_stream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'voice_state.dart';

class VoiceCubit extends Cubit<VoiceState> {
  final StartVoiceStream startVoiceStream;
  final StopVoiceStream stopVoiceStream;
  final ListenVoiceStream listenVoiceStream;
  final VoiceRepository repository;

  StreamSubscription? _sub;

  /// Waveform widgets listen to this directly — no controller needed.
  Stream<double> get amplitudeStream => repository.amplitudeStream;

  VoiceCubit({
    required this.startVoiceStream,
    required this.stopVoiceStream,
    required this.listenVoiceStream,
    required this.repository,
  }) : super(const VoiceState());

  // ── Start ─────────────────────────────────────────────────────────────────

  Future<void> startListening() async {
    final granted = await _ensureMicrophonePermission();
    if (!granted) {
      emit(
        state.copyWith(
          status: VoiceStatus.error,
          error: 'Microphone permission denied',
        ),
      );
      return;
    }

    emit(state.copyWith(status: VoiceStatus.listening, transcript: ''));

    // Open WebSocket + start mic capture + start amplitude polling.
    await startVoiceStream();

    // Subscribe to server messages BEFORE stop is called.
    _listenToStream();
  }

  // ── Stop ──────────────────────────────────────────────────────────────────

  Future<void> stopListening() async {
    // Sends END_SESSION + stops mic + stops amplitude polling.
    // Does NOT close the socket — BE will still send terminal events.
    await stopVoiceStream();

    emit(state.copyWith(status: VoiceStatus.processing));
  }

  // ── Reset (after done / error) ────────────────────────────────────────────

  void reset() => emit(const VoiceState());

  // ── Socket stream ─────────────────────────────────────────────────────────

  void _listenToStream() {
    _sub?.cancel();

    _sub = listenVoiceStream().listen(
      _handleServerMessage,
      onError: (_) {
        emit(
          state.copyWith(status: VoiceStatus.error, error: 'Connection error'),
        );
        _cancelSub();
      },
      onDone: () {
        if (state.isProcessing || state.isListening) {
          emit(
            state.copyWith(
              status: VoiceStatus.error,
              error: 'Connection closed unexpectedly',
            ),
          );
        }
      },
    );
  }

  void _handleServerMessage(String raw) {
    final Map<String, dynamic> data;
    try {
      data = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return;
    }

    final type = data['type'] as String?;
    final payload = data['payload'] as Map<String, dynamic>?;

    switch (type) {
      case 'SESSION_READY':
        // Deepgram is open and receiving audio — already in listening state.
        break;

      case 'TRANSCRIPT_PARTIAL':
        final text = payload?['transcript'] as String?;
        if (text != null && state.isListening) {
          emit(state.copyWith(transcript: text));
        }
        break;

      case 'TRANSCRIPT_FINAL':
        final text = payload?['transcript'] as String?;
        if (text != null && state.isListening) {
          final updated = state.transcript.isEmpty
              ? text
              : '${state.transcript} $text';
          emit(state.copyWith(transcript: updated));
        }
        break;

      case 'PROCESSING':
        emit(state.copyWith(status: VoiceStatus.processing));
        break;

      case 'EXPENSES_SAVED':
        emit(state.copyWith(status: VoiceStatus.done));
        _closeConnection();
        break;

      case 'ERROR':
        final message =
            payload?['message'] as String? ?? 'Something went wrong';
        emit(state.copyWith(status: VoiceStatus.error, error: message));
        _closeConnection();
        break;
    }
  }

  // ── Permission ────────────────────────────────────────────────────────────

  Future<bool> _ensureMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;

    final result = await Permission.microphone.request();
    if (result.isPermanentlyDenied) openAppSettings();
    return result.isGranted;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _cancelSub() {
    _sub?.cancel();
    _sub = null;
  }

  Future<void> _closeConnection() async {
    _cancelSub();
    await repository.closeSocket();
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  Future<void> close() async {
    _cancelSub();
    await stopVoiceStream().catchError((_) {});
    await repository.closeSocket().catchError((_) {});
    repository.dispose();
    return super.close();
  }
}
