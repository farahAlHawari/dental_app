part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordEvent {}

final class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String resetToken;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordSubmitted({
    required this.resetToken,
    required this.newPassword,
    required this.confirmPassword,
  });
}
