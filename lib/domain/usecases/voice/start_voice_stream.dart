import 'package:electra/domain/repository/voice/voice_repository.dart';

class StartVoiceStream {
  final VoiceRepository repository;

  StartVoiceStream(this.repository);

  Future<void> call() {
    return repository.startStream();
  }
}
