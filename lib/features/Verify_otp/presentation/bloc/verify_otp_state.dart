part of 'verify_otp_bloc.dart';

@immutable
sealed class VerifyOtpState {}

final class VerifyOtpInitial extends VerifyOtpState {}
final class VerifyOtpLoading extends VerifyOtpState {}

final class VerifyOtpSuccess extends VerifyOtpState {
  final bool activationRequired;
  final String accountStatus;
  final String? temporaryToken;

  VerifyOtpSuccess({
    required this.activationRequired,
    required this.accountStatus,
    this.temporaryToken,
  });
}
final class VerifyOtpFailure extends VerifyOtpState {
  final String failureMessage;
  VerifyOtpFailure({required this.failureMessage});
}