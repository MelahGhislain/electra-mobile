import 'package:electra/data/repository/user/user_repository_impl.dart';
import 'package:electra/domain/entities/user/user.dart';

class GetCurrentUser {
  final UserRepositoryImpl repository;

  GetCurrentUser(this.repository);

  Future<User> call() {
    return repository.getCurrentUser();
  }
}