import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qleo/core/errors/dio_error_mapper.dart';
import 'package:qleo/core/errors/failures.dart';
import 'package:qleo/data/source/notification/notification_datasource.dart';
import 'package:qleo/domain/entities/notification/notification.dart';
import 'package:qleo/domain/repository/notification/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> registerPushToken(
    String token,
    String platform,
  ) async {
    try {
      await remoteDataSource.registerPushToken(token, platform);
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removePushToken(String token) async {
    try {
      await remoteDataSource.removePushToken(token);
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final models = await remoteDataSource.getNotifications();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markAllRead() async {
    try {
      await remoteDataSource.markAllRead();
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await remoteDataSource.getUnreadCount();
      return Right(count);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
