import 'package:dartz/dartz.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/data/repository/user/user_repository_impl.dart';
import 'package:electra/domain/entities/user/user_settings.dart';

class UpdateUserSettingUsecase {
  final UserRepositoryImpl repository;

  UpdateUserSettingUsecase(this.repository);

  Future<Either<Failure, UserSettings>> call(
    String id,
    Map<String, dynamic> body,
  ) => repository.updateSettings(id, body);
}
