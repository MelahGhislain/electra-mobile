import 'package:dartz/dartz.dart';
import 'package:minata/core/errors/failures.dart';
import 'package:minata/domain/entities/notification/notification.dart';

abstract class NotificationRepository {
  Future<Either<Failure, void>> registerPushToken(
    String token,
    String platform,
  );
  Future<Either<Failure, void>> removePushToken(String token);
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAllRead();
  Future<Either<Failure, int>> getUnreadCount();
}
