import 'package:dartz/dartz.dart';
import 'package:electra/core/enums/auth_provider_enum.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/auth/auth_tokens.dart';
import 'package:electra/domain/entities/auth/social_auth_credential.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokens>> register({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, AuthTokens>> refresh({required String refreshToken});
  Future<Either<Failure, void>> logout(AuthProviderEnum? authProvider);

  // OAuth
  Future<Either<Failure, AuthTokens>> loginWithSocial(
    SocialAuthCredential credential,
  );
}
