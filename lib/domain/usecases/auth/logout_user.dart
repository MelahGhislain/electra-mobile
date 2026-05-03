import 'package:electra/core/enums/auth_provider_enum.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';

class LogoutUser {
  final AuthRepository repository;

  LogoutUser(this.repository);

  Future<Either<Failure, void>> call(AuthProviderEnum? authProvider) async {
    return repository.logout(authProvider);
  }
}
