import 'package:electra/data/source/user/user_datasource.dart';
import 'package:electra/domain/entities/user/user.dart';
import 'package:electra/domain/repository/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;

  UserRepositoryImpl(this.remote);

  @override
  Future<User> getCurrentUser() async {
    return await remote.getUser();
  }
}
