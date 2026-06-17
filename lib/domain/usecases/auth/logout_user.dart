import 'package:qleo/core/enums/auth_provider_enum.dart';
import 'package:qleo/domain/repository/auth/auth_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:qleo/core/errors/failures.dart';

class LogoutUser {
  final AuthRepository repository;

  LogoutUser(this.repository);

  Future<Either<Failure, void>> call(AuthProviderEnum? authProvider) async {
    return repository.logout(authProvider);
  }
}
