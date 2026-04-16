import 'package:electra/core/configs/env.dart';

class ApiEndpoints {
  static String get baseUrl => Env.apiBaseUrl;

  // Auth endpoints
  static const login = "/auth/login";
  static const register = "/auth/register";
  static const refresh = "/auth/refresh";
  static const logout = "/auth/logout";
  static const voiceStream = "/voice-stream";

  // User endpoints
  static const me = "/auth/me";
}
