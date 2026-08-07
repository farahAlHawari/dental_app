part of 'change_phone_bloc.dart';

@immutable
sealed class ChangePhoneState {}

final class ChangePhoneInitial extends ChangePhoneState {}

final class ChangePhoneLoading extends ChangePhoneState {}

final class ChangePhoneSuccess extends ChangePhoneState {
  final String newPhone;
  ChangePhoneSuccess({required this.newPhone});
}

final class ChangePhoneFailure extends ChangePhoneState {
  final String errMessage;
  ChangePhoneFailure({required this.errMessage});
}
