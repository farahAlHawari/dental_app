part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

final class RegisterSubmitted extends RegisterEvent {
  final String phone;
  final String password;
  final String confirmPassword;
  final String language;

  RegisterSubmitted({
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.language,
  });
}