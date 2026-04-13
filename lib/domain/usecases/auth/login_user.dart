

import 'package:electra/data/models/auth/signin_user_dto.dart';
import 'package:electra/domain/entities/auth/auth_tokens.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<AuthTokens> call(SigninUserDto data) {
    return repository.login(data);
  }
}