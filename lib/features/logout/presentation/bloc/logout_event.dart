// logout_event.dart
part of 'logout_bloc.dart';

@immutable
sealed class LogoutEvent {}

final class LogoutRequested extends LogoutEvent {}