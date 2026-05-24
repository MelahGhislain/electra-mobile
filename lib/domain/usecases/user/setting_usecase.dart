import 'package:dartz/dartz.dart';
import 'package:minata/core/errors/failures.dart';
import 'package:minata/data/repository/user/user_repository_impl.dart';
import 'package:minata/domain/entities/user/user_settings.dart';

class UpdateUserSettingUsecase {
  final UserRepositoryImpl repository;

  UpdateUserSettingUsecase(this.repository);

  Future<Either<Failure, UserSettings>> call(
    String id,
    Map<String, dynamic> body,
  ) => repository.updateSettings(id, body);
}
