import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:electra/core/errors/dio_error_mapper.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/data/source/user/user_datasource.dart';
import 'package:electra/domain/entities/user/user.dart';
import 'package:electra/domain/entities/user/user_settings.dart';
import 'package:electra/domain/repository/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getUser();
      return Right(user.toEntity());
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      final user = await remoteDataSource.updateUser(id, body);
      return Right(user.toEntity());
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await remoteDataSource.deleteUser(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserSettings>> getSettings(String id) async {
    try {
      final settings = await remoteDataSource.getSettings(id);
      return Right(settings.toEntity());
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserSettings>> updateSettings(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      final settings = await remoteDataSource.updateSettings(id, body);
      return Right(settings.toEntity());
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
