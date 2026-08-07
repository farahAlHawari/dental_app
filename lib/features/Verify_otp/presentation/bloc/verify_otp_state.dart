part of 'verify_otp_bloc.dart';

@immutable
sealed class VerifyOtpState {}

final class VerifyOtpInitial extends VerifyOtpState {}

final class VerifyOtpLoading extends VerifyOtpState {}

final class VerifyOtpSuccess extends VerifyOtpState {
  final bool activationRequired;
  final String accountStatus;
  final String? temporaryToken;
  final String? resetToken;

  VerifyOtpSuccess({
    required this.activationRequired,
    required this.accountStatus,
    this.temporaryToken,
    this.resetToken,
  });
}

final class VerifyOtpFailure extends VerifyOtpState {
  final String failureMessage;
  final String? errorCode;

  VerifyOtpFailure({
    required this.failureMessage,
    this.errorCode,
  });
}
