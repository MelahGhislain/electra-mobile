import 'package:electra/domain/repository/voice/voice_repository.dart';
import 'package:electra/data/source/voice/voice_stream_service.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  final VoiceStreamService service;

  VoiceRepositoryImpl(this.service);

  @override
  Future<void> startStream() => service.start();

  @override
  Future<void> stopStream() => service.stop();

  @override
  void dispose() {
    service.dispose();
  }

  @override
  Stream<String> get textStream => service.textStream;
}
