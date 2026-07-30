part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}
final class LoginLoading extends LoginState {}
final class LoginSuccess extends LoginState {}
final class LoginRequiresPasswordChange extends LoginState {
  final String temporaryToken;
  LoginRequiresPasswordChange({required this.temporaryToken});
}
final class LoginFailure extends LoginState {
  final String errMessage;
  LoginFailure({required this.errMessage});
}