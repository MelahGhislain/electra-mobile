import 'package:qleo/domain/entities/notification/notification.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  NotificationLoaded copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
  }) => NotificationLoaded(
    notifications: notifications ?? this.notifications,
    unreadCount: unreadCount ?? this.unreadCount,
  );

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotificationFailure extends NotificationState {
  final String message;

  const NotificationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationTokenRegistered extends NotificationState {
  const NotificationTokenRegistered();
}
