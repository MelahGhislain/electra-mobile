import 'package:electra/domain/repository/voice/voice_repository.dart';

class ListenVoiceStream {
  final VoiceRepository repository;

  ListenVoiceStream(this.repository);

  Stream<String> call() {
    return repository.textStream;
  }
}
