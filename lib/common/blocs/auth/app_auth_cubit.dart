import 'package:qleo/core/services/fcm_service.dart';
import 'package:qleo/data/repository/auth/auth_repository_impl.dart';
import 'package:qleo/domain/usecases/notification/notification_usecase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qleo/core/utils/storage/auth_storage.dart';
import 'app_auth_state.dart';

class AppAuthCubit extends Cubit<AppAuthState> {
  final AuthStorage _storage;
  final AuthRepositoryImpl _authRepository;
  final FcmService _fcmService;
  final RemovePushTokenUsecase _removePushToken;

  AppAuthCubit(
    this._storage,
    this._authRepository,
    this._fcmService,
    this._removePushToken,
  ) : super(const AppAuthState.unknown());

  /// Full bootstrap check:
  /// 1. No tokens at all      → unauthenticated (first time or logged out)
  /// 2. Has access token      → authenticated (interceptor will refresh if needed)
  /// 3. Only refresh token    → try to refresh now; if fails → unauthenticated
  Future<void> checkAuthStatus() async {
    try {
      final accessToken = await _storage.accessToken;
      final refreshToken = await _storage.refreshToken;

      // No tokens at all — definitely unauthenticated
      if (accessToken == null && refreshToken == null) {
        emit(const AppAuthState.unauthenticated());
        return;
      }

      // Has access token — mark authenticated optimistically.
      // If it's expired the interceptor will refresh on first 401.
      if (accessToken != null && accessToken.isNotEmpty) {
        emit(const AppAuthState.authenticated());
        return;
      }

      // Has refresh token only — proactively refresh before hitting any endpoint
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final result = await _authRepository.refresh(
          refreshToken: refreshToken,
        );
        result.fold((failure) {
          _storage.clearTokens();
          emit(const AppAuthState.unauthenticated());
        }, (_) => emit(const AppAuthState.authenticated()));
        return;
      }

      emit(const AppAuthState.unauthenticated());
    } catch (_) {
      await _storage.clearTokens();
      emit(const AppAuthState.unauthenticated());
    }
  }

  Future<void> onLoginSuccess() async {
    // TODO: Uncomment and test this once notification is ready to be done
    // await _fcmService.init();
    emit(const AppAuthState.authenticated());
  }

  Future<void> onLogout() async {
    try {
      // On iOS, FCM requires the APNs token before it can return an FCM token.
      // If APNs hasn't registered yet (e.g. simulator, no network, first boot),
      // getToken() throws — we skip token removal and proceed with logout anyway.
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _removePushToken(token);
      }
    } catch (_) {
      // Token removal is best-effort — a failed unregister should never
      // block the user from logging out. The token will expire naturally.
    } finally {
      await _storage.clearTokens();
      emit(const AppAuthState.unauthenticated());
    }
  }
}
