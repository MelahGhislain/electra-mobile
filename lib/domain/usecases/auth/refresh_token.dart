import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/auth/auth_tokens.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';

import 'package:dartz/dartz.dart';

class RefreshToken {
  final AuthRepository repository;

  RefreshToken(this.repository);

  Future<Either<Failure, AuthTokens>> call({
    required String refreshToken,
  }) async {
    return repository.refresh(refreshToken: refreshToken);
  }
}
