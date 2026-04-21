import 'package:electra/domain/repository/auth/auth_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';

class LogoutUser {
  final AuthRepository repository;

  LogoutUser(this.repository);

  Future<Either<Failure, void>> call() async {
    return repository.logout();
  }
}
