import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/data/repository/user/user_repository_impl.dart';
import 'package:electra/domain/entities/user/user.dart';

class GetCurrentUserUsecase {
  final UserRepositoryImpl repository;

  GetCurrentUserUsecase(this.repository);

  Future<Either<Failure, User>> call() => repository.getCurrentUser();
}

class UpdateUserUsecase {
  final UserRepositoryImpl repository;

  UpdateUserUsecase(this.repository);

  Future<Either<Failure, User>> call(String id, Map<String, dynamic> body) =>
      repository.updateUser(id, body);
}

class DeleteUserUsecase {
  final UserRepositoryImpl repository;

  DeleteUserUsecase(this.repository);

  Future<Either<Failure, void>> call(String id) => repository.deleteUser(id);
}
