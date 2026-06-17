import 'package:qleo/core/utils/storage/auth_storage.dart';
import 'package:qleo/domain/repository/voice/voice_repository.dart';
import 'package:qleo/data/source/voice/voice_stream_service.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  final AuthStorage _authStorage;

  // Service is created fresh on each startStream() call so the token
  // is always current. Kept nullable so closeSocket/dispose still work
  // if called before start.
  VoiceStreamService? _service;

  VoiceRepositoryImpl(this._authStorage);

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Reads the current access token from storage.
  /// Throws if no token is available — user must be logged in.
  Future<String> _getFreshToken() async {
    final token = await _authStorage.accessToken;
    if (token == null || token.isEmpty) {
      throw Exception('No access token available. Please log in again.');
    }
    return token;
  }

  // ── VoiceRepository ────────────────────────────────────────────────────────

  @override
  Future<void> startStream() async {
    // Always read a fresh token right before connecting.
    // AuthStorage.accessToken returns the stored JWT — the Dio interceptor
    // handles refresh for HTTP calls, but WS needs it pre-flight here.
    final token = await _getFreshToken();

    // Create a new service instance each session — guarantees a clean
    // WebSocket connection with a fresh token every time.
    _service = VoiceStreamService(token: token);
    return _service!.start();
  }

  @override
  Future<void> stopStream() async => _service?.stop();

  @override
  Future<void> closeSocket() async => _service?.closeSocket();

  @override
  Stream<String> get textStream {
    // Return empty stream — cubit will handle the error state if called
    // before startStream().
    if (_service == null) return const Stream.empty();
    return _service!.textStream;
  }

  @override
  Stream<double> get amplitudeStream {
    if (_service == null) return const Stream.empty();
    return _service!.amplitudeStream;
  }

  @override
  void dispose() {
    _service?.dispose();
    _service = null;
  }
}
