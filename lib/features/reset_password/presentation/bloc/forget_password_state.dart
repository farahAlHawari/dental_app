part of 'forget_password_bloc.dart';

@immutable
sealed class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}
final class ForgetPasswordLoading extends ForgetPasswordState {}

final class ForgetPasswordSuccess extends ForgetPasswordState {
  final String phone;
  ForgetPasswordSuccess({required this.phone});
}

final class ForgetPasswordFailure extends ForgetPasswordState {
  final String failureMessage;
  ForgetPasswordFailure({required this.failureMessage});
}