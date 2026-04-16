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
    // ✅ Check permission FIRST
    final hasRecordingPerm = await recorderController.checkPermission();

    if (!hasRecordingPerm) {
      // Request permission if not granted
      final permission = await Permission.microphone.request();
      if (!permission.isGranted) {
        emit(state.copyWith(isListening: false, text: 'Permission denied'));
        return;
      }
    }

    await recorderController.record(
      recorderSettings: const RecorderSettings(
        sampleRate: 44100,
        bitRate: 128000,
        iosEncoderSettings: IosEncoderSetting(
          iosEncoder: IosEncoder.kAudioFormatMPEG4AAC,
        ),
        androidEncoderSettings: AndroidEncoderSettings(
          androidEncoder: AndroidEncoder.aacLc,
        ),
      ),
    );

    emit(state.copyWith(isListening: true, text: ''));

    await startVoiceStream();

    _sub = listenVoiceStream().listen((text) {
      emit(state.copyWith(text: text));
    });
  }

  Future<void> stopListening() async {
    await recorderController.stop();

    await stopVoiceStream();
    await _sub?.cancel();

    emit(state.copyWith(isListening: false));
  }

  @override
  Future<void> close() async {
    await stopListening(); // 🔥 ensures mic + socket closed
    repository.dispose(); // 🔥 ensures memory cleanup
    recorderController.dispose();
    return super.close();
  }
}
