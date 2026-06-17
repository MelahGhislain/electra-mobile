import 'package:qleo/core/errors/failures.dart';
import 'package:qleo/domain/entities/auth/auth_tokens.dart';
import 'package:qleo/domain/repository/auth/auth_repository.dart';

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
