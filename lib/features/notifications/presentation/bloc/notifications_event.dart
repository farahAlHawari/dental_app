part of 'notifications_bloc.dart';

@immutable
sealed class NotificationsEvent {}

final class LoadNotificationsRequested extends NotificationsEvent {
  /// null = all, true = read only, false = unread only
  final bool? isRead;
  final int page;
  final int pageSize;

  LoadNotificationsRequested({
    this.isRead,
    this.page = 1,
    this.pageSize = 20,
  });
}

final class LoadUnreadCountRequested extends NotificationsEvent {}

final class MarkAllNotificationsReadRequested extends NotificationsEvent {}

final class MarkNotificationReadRequested extends NotificationsEvent {
  final String id;

  MarkNotificationReadRequested({required this.id});
}
