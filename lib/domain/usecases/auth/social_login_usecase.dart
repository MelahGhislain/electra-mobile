import 'package:dartz/dartz.dart';
import 'package:minata/core/errors/failures.dart';
import 'package:minata/domain/entities/auth/auth_tokens.dart';
import 'package:minata/domain/entities/auth/social_auth_credential.dart';
import 'package:minata/domain/repository/auth/auth_repository.dart';

class SocialLoginUseCase {
  final AuthRepository repository;
  const SocialLoginUseCase(this.repository);

  Future<Either<Failure, AuthTokens>> call(SocialAuthCredential credential) =>
      repository.loginWithSocial(credential);
}
