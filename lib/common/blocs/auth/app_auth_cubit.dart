import 'package:electra/data/repository/auth/auth_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electra/core/utils/storage/auth_storage.dart';
import 'app_auth_state.dart';

class AppAuthCubit extends Cubit<AppAuthState> {
  final AuthStorage _storage;
  final AuthRepositoryImpl _authRepository;

  AppAuthCubit(this._storage, this._authRepository)
    : super(const AppAuthState.unknown());

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

  void onLoginSuccess() => emit(const AppAuthState.authenticated());

  void onLogout() => emit(const AppAuthState.unauthenticated());
}
