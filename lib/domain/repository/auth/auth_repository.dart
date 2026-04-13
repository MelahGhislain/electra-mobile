import 'package:electra/data/models/auth/signup_user_dto.dart';
import 'package:electra/data/models/auth/signin_user_dto.dart';
import 'package:electra/domain/entities/auth/auth_tokens.dart';

abstract class AuthRepository {
  Future<AuthTokens> signup(SignupUserDto data);
  Future<AuthTokens> login(SigninUserDto data);
  Future<AuthTokens> refresh({required String refreshToken});
  Future<void> logout();
}