import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'development';

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.electra.app';
  static String get webSocketUrl =>
      dotenv.env['WEB_SOCKET_URL'] ?? 'wss://api.electra.app/ws';

  // Helper to check environment
  static bool get isDevelopment => appEnv == 'development';
  static bool get isStaging => appEnv == 'staging';
  static bool get isProduction => appEnv == 'production';

  // Optional: Print all loaded variables in debug
  static void debugPrintAll() {
    if (isDevelopment) {
      dotenv.env.forEach((key, value) {
        print('ENV → $key: $value');
      });
    }
  }
}
