import 'package:electra/domain/repository/voice/voice_repository.dart';

class StopVoiceStream {
  final VoiceRepository repository;

  StopVoiceStream(this.repository);

  Future<void> call() {
    return repository.stopStream();
  }
}
