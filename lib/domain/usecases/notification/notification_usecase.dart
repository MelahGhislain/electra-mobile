import 'package:dartz/dartz.dart';
import 'package:minata/core/errors/failures.dart';
import 'package:minata/data/repository/notification/notification_repository_impl.dart';
import 'package:minata/domain/entities/notification/notification.dart';

class RegisterPushTokenUsecase {
  final NotificationRepositoryImpl repository;

  RegisterPushTokenUsecase(this.repository);

  Future<Either<Failure, void>> call(String token, String platform) =>
      repository.registerPushToken(token, platform);
}

class RemovePushTokenUsecase {
  final NotificationRepositoryImpl repository;

  RemovePushTokenUsecase(this.repository);

  Future<Either<Failure, void>> call(String token) =>
      repository.removePushToken(token);
}

class GetNotificationsUsecase {
  final NotificationRepositoryImpl repository;

  GetNotificationsUsecase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call() =>
      repository.getNotifications();
}

class MarkAllReadUsecase {
  final NotificationRepositoryImpl repository;

  MarkAllReadUsecase(this.repository);

  Future<Either<Failure, void>> call() => repository.markAllRead();
}

class GetUnreadCountUsecase {
  final NotificationRepositoryImpl repository;

  GetUnreadCountUsecase(this.repository);

  Future<Either<Failure, int>> call() => repository.getUnreadCount();
}
