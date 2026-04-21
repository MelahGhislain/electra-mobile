import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/auth/auth_tokens.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;
  const LoginUser(this.repository);

  Future<Either<Failure, AuthTokens>> call({
    required String email,
    required String password,
  }) => repository.login(email: email, password: password);
}
