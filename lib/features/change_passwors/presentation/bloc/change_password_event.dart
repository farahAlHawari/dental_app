part of 'change_password_bloc.dart';

@immutable
sealed class ChangePasswordEvent {}

final class ChangePasswordSubmitted extends ChangePasswordEvent {
  final String currentPassword;
  final String newPassword;
  ChangePasswordSubmitted({
    required this.currentPassword,
    required this.newPassword,
  });
}