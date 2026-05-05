import 'package:electra/core/enums/auth_provider_enum.dart';
import 'package:electra/data/repository/auth/auth_repository_impl.dart';
import 'package:electra/domain/entities/user/user.dart';
import 'package:electra/domain/usecases/auth/login_user.dart';
import 'package:electra/domain/usecases/auth/logout_user.dart';
import 'package:electra/domain/usecases/auth/register_user.dart';
import 'package:electra/domain/usecases/auth/social_login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUser loginUseCase;
  final RegisterUser registerUseCase;
  final LogoutUser logoutUseCase;
  final SocialLoginUseCase socialLoginUseCase;
  final AuthRepositoryImpl repository;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.socialLoginUseCase,
    required this.repository,
  }) : super(const AuthInitial());

  // ── Email / Password ───────────────────────────────────────────────────────
  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await loginUseCase(email: email, password: password);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(const AuthSuccess()),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await registerUseCase(
      name: name,
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(const AuthSuccess()),
    );
  }

  Future<void> logout(User? user) async {
    emit(const AuthLoading());
    final result = await logoutUseCase(_mapProvider(user?.provider));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(const AuthLoggedOut()),
    );
  }

  // ── OAuth ──────────────────────────────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading());
    final result = await repository.signInWithGoogle();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (token) => token == null
          ? emit(const AuthCancelled())
          : emit(const AuthSuccess()),
    );
  }

  Future<void> signInWithApple() async {
    emit(const AuthLoading());
    final result = await repository.signInWithApple();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (token) => token == null
          ? emit(const AuthCancelled())
          : emit(const AuthSuccess()),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void reset() => emit(const AuthInitial());

  AuthProviderEnum? _mapProvider(String? provider) {
    switch (provider) {
      case 'google':
        return AuthProviderEnum.google;
      case 'apple':
        return AuthProviderEnum.apple;
      case 'email':
        return AuthProviderEnum.email;
      default:
        return null;
    }
  }
}
