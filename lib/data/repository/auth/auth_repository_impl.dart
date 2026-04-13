import 'package:electra/data/source/auth/auth_datasource.dart';
import 'package:electra/data/models/auth/signup_user_dto.dart';
import 'package:electra/data/models/auth/signin_user_dto.dart';
import 'package:electra/domain/entities/auth/auth_tokens.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<AuthTokens> login(SigninUserDto signinUser) async {
    return await remote.login(signinUser);
  }

  @override
  Future<AuthTokens> signup(SignupUserDto signupUser) async {
    return await remote.register(signupUser);
  }

  @override
  Future<AuthTokens> refresh({required String refreshToken}) async {
    return await remote.refresh(refreshToken: refreshToken);
  }

  @override
  Future<void> logout() async {
    await remote.logout();
  }
}
