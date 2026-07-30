part of 'verify_otp_bloc.dart';

@immutable
sealed class VerifyOtpEvent {}

final class VerifyOtpSubmitted extends VerifyOtpEvent {
  final String phone;
  final String code;
  VerifyOtpSubmitted({required this.phone, required this.code});
}