import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:qleo/domain/usecases/notification/notification_usecase.dart';

/// Top-level handler required by FCM for background/terminated messages.
/// Must be a top-level function (not a class method).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you need Firebase here, ensure it's initialized before this runs.
  // Firebase.initializeApp() is idempotent so it's safe to call again.
  debugPrint('[FCM] Background message: ${message.messageId}');
}

class FcmService {
  FcmService({required RegisterPushTokenUsecase registerToken})
    : _registerToken = registerToken;

  final RegisterPushTokenUsecase _registerToken;
  final _messaging = FirebaseMessaging.instance;

  /// Call once from main() — before runApp().
  static void registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Call after the user is authenticated (e.g. inside AppAuthCubit or
  /// right after a successful login). Requests permission, fetches the
  /// FCM token, and registers it with your backend.
  Future<void> init() async {
    await _requestPermission();

    final token = await _messaging.getToken();
    if (token != null) {
      await _sendTokenToServer(token);
    }

    // Keep the token fresh — FCM rotates it occasionally.
    _messaging.onTokenRefresh.listen(_sendTokenToServer);

    // Handle messages that open the app from a terminated state.
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _handleMessage(initial);

    // Handle messages that open the app from the background.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Handle foreground messages.
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('[FCM] Permission: ${settings.authorizationStatus}');
  }

  Future<void> _sendTokenToServer(String token) async {
    final platform = Platform.isIOS ? 'ios' : 'android';
    final result = await _registerToken(token, platform);
    result.fold(
      (failure) =>
          debugPrint('[FCM] Token registration failed: ${failure.message}'),
      (_) => debugPrint('[FCM] Token registered'),
    );
  }

  /// Called when a notification opens the app.
  /// Add your navigation / deep-link logic here.
  void _handleMessage(RemoteMessage message) {
    debugPrint('[FCM] Opened from notification: ${message.data}');
  }

  /// Called while the app is in the foreground.
  /// Show a local notification or update the in-app badge here.
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('[FCM] Foreground message: ${message.notification?.title}');
  }
}
