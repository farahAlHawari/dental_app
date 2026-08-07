part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}
final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final String phone;
  RegisterSuccess({required this.phone});
}

final class RegisterFailure extends RegisterState {
  final String errMessage;
  final int? statusCode;
  RegisterFailure({required this.errMessage, this.statusCode});
}