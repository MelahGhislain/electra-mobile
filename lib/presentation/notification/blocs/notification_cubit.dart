import 'package:electra/domain/usecases/notification/notification_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final RegisterPushTokenUsecase _registerToken;
  final RemovePushTokenUsecase _removeToken;
  final GetNotificationsUsecase _getNotifications;
  final MarkAllReadUsecase _markAllRead;
  final GetUnreadCountUsecase _getUnreadCount;

  NotificationCubit({
    required RegisterPushTokenUsecase registerToken,
    required RemovePushTokenUsecase removeToken,
    required GetNotificationsUsecase getNotifications,
    required MarkAllReadUsecase markAllRead,
    required GetUnreadCountUsecase getUnreadCount,
  }) : _registerToken = registerToken,
       _removeToken = removeToken,
       _getNotifications = getNotifications,
       _markAllRead = markAllRead,
       _getUnreadCount = getUnreadCount,
       super(const NotificationInitial());

  // ── Token ──────────────────────────────────────────────────────────────────

  Future<void> registerPushToken(String token, String platform) async {
    final result = await _registerToken(token, platform);
    result.fold(
      (failure) => emit(NotificationFailure(failure.message)),
      (_) => emit(const NotificationTokenRegistered()),
    );
  }

  Future<void> removePushToken(String token) async {
    final result = await _removeToken(token);
    result.fold(
      (failure) => emit(NotificationFailure(failure.message)),
      (_) => emit(const NotificationInitial()),
    );
  }

  // ── Inbox ──────────────────────────────────────────────────────────────────

  Future<void> loadNotifications() async {
    emit(const NotificationLoading());

    final notifResult = await _getNotifications();
    final countResult = await _getUnreadCount();

    final notifications = notifResult.fold((_) => null, (n) => n);
    final count = countResult.fold((_) => 0, (c) => c);

    if (notifications == null) {
      notifResult.fold(
        (failure) => emit(NotificationFailure(failure.message)),
        (_) {},
      );
      return;
    }

    emit(NotificationLoaded(notifications: notifications, unreadCount: count));
  }

  // ── Mark all read ──────────────────────────────────────────────────────────

  Future<void> markAllRead() async {
    final previous = _currentLoaded();
    if (previous == null) return;

    final result = await _markAllRead();
    result.fold((failure) => emit(NotificationFailure(failure.message)), (_) {
      final updated = previous.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      emit(previous.copyWith(notifications: updated, unreadCount: 0));
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  NotificationLoaded? _currentLoaded() {
    final s = state;
    return s is NotificationLoaded ? s : null;
  }

  int get unreadCount {
    final s = state;
    return s is NotificationLoaded ? s.unreadCount : 0;
  }

  bool get hasUnread => unreadCount > 0;
}
