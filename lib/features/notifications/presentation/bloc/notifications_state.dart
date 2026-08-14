part of 'notifications_bloc.dart';

@immutable
sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsListLoading extends NotificationsState {}

final class NotificationsListSuccess extends NotificationsState {
  final Map<String, dynamic> data;
  NotificationsListSuccess({required this.data});
}

final class NotificationsListFailure extends NotificationsState {
  final String errMessage;
  NotificationsListFailure({required this.errMessage});
}

final class NotificationsUnreadCountSuccess extends NotificationsState {
  final int count;
  NotificationsUnreadCountSuccess({required this.count});
}

final class NotificationsActionFailure extends NotificationsState {
  final String errMessage;
  NotificationsActionFailure({required this.errMessage});
}

final class MarkAllReadSuccess extends NotificationsState {
  final int count;
  MarkAllReadSuccess({required this.count});
}

final class MarkOneReadSuccess extends NotificationsState {
  final String id;
  final Map<String, dynamic> data;
  MarkOneReadSuccess({required this.id, required this.data});
}
