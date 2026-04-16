import 'package:electra/domain/entities/user/user.dart';

abstract class UserRepository {
  Future<User> getCurrentUser();
}
