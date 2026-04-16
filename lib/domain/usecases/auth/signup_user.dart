import 'package:electra/data/models/auth/signup_user_dto.dart';
import 'package:electra/domain/entities/auth/auth_tokens.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';

class SignupUser {
  final AuthRepository repository;

  SignupUser(this.repository);

  Future<AuthTokens> call(SignupUserDto data) {
    return repository.signup(data);
  }
}
