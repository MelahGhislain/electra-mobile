import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/auth/auth_tokens.dart';
import 'package:electra/domain/entities/auth/social_auth_credential.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';

class SocialLoginUseCase {
  final AuthRepository repository;
  const SocialLoginUseCase(this.repository);

  Future<Either<Failure, AuthTokens>> call(SocialAuthCredential credential) =>
      repository.loginWithSocial(credential);
}
