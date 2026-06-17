import 'package:dartz/dartz.dart';
import 'package:qleo/core/errors/failures.dart';
import 'package:qleo/domain/entities/auth/auth_tokens.dart';
import 'package:qleo/domain/entities/auth/social_auth_credential.dart';
import 'package:qleo/domain/repository/auth/auth_repository.dart';

class SocialLoginUseCase {
  final AuthRepository repository;
  const SocialLoginUseCase(this.repository);

  Future<Either<Failure, AuthTokens>> call(SocialAuthCredential credential) =>
      repository.loginWithSocial(credential);
}
