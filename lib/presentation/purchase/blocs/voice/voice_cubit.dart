import 'dart:async';
import 'package:electra/domain/repository/voice/voice_repository.dart';
import 'package:electra/domain/usecases/voice/start_voice_stream.dart';
import 'package:electra/domain/usecases/voice/stop_voice_stream.dart';
import 'package:electra/domain/usecases/voice/listen_voice_stream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'voice_state.dart';

class VoiceCubit extends Cubit<VoiceState> {
  final StartVoiceStream startVoiceStream;
  final StopVoiceStream stopVoiceStream;
  final ListenVoiceStream listenVoiceStream;
  final VoiceRepository repository;

  final recorderController = RecorderController();

  StreamSubscription? _sub;

  VoiceCubit({
    required this.startVoiceStream,
    required this.stopVoiceStream,
    required this.listenVoiceStream,
    required this.repository,
  }) : super(const VoiceState());

  Future<void> startListening() async {
    final granted = await _ensureMicrophonePermission();

    if (!granted) {
      emit(
        state.copyWith(
          isListening: false,
          text: 'Microphone permission denied',
        ),
      );
      return;
    }

    // await _startRecording();
    recorderController.record();

    emit(state.copyWith(isListening: true, text: ''));

    await startVoiceStream();

    _listenToStream();
  }

  Future<void> stopListening() async {
    // Stop waveform animation
    await recorderController.stop();

    await _sub?.cancel();
    await stopVoiceStream();

    emit(state.copyWith(isListening: false));
  }

  Future<bool> _ensureMicrophonePermission() async {
    final status = await Permission.microphone.status;

    if (status.isGranted) return true;

    final result = await Permission.microphone.request();

    if (result.isPermanentlyDenied) {
      openAppSettings(); // 🔥 important UX
    }

    return result.isGranted;
  }

  void _listenToStream() {
    _sub?.cancel(); // 🔥 prevent memory leaks

    _sub = listenVoiceStream().listen(
      (text) {
        emit(state.copyWith(text: text));
      },
      onError: (_) {
        emit(state.copyWith(isListening: false, text: 'Something went wrong'));
      },
    );
  }

  @override
  Future<void> close() async {
    await stopListening(); // 🔥 ensures mic + socket closed
    repository.dispose(); // 🔥 ensures memory cleanup
    recorderController.dispose();
    return super.close();
  }
}
