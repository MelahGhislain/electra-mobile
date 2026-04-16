abstract class VoiceRepository {
  Future<void> startStream();
  Future<void> stopStream();
  Stream<String> get textStream;

  void dispose();
}
