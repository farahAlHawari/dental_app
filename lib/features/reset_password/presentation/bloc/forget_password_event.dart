part of 'forget_password_bloc.dart';

@immutable
sealed class ForgetPasswordEvent {}

final class ForgetPasswordSubmitted extends ForgetPasswordEvent {
  final String phone;
  ForgetPasswordSubmitted({required this.phone});
}