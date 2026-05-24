abstract class VoiceRepository {
  Future<void> startStream();
  Future<void> stopStream();
  Future<void> closeSocket();
  Stream<String> get textStream;
  Stream<double> get amplitudeStream;
  void dispose();
}
