import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/domain/entities/user/user.dart';
import 'package:electra/domain/entities/user/user_settings.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, User>> updateUser(
    String id,
    Map<String, dynamic> body,
  );
  Future<Either<Failure, void>> deleteUser(String id);
  Future<Either<Failure, UserSettings>> getSettings(String id);
  Future<Either<Failure, UserSettings>> updateSettings(
    String id,
    Map<String, dynamic> body,
  );
}
