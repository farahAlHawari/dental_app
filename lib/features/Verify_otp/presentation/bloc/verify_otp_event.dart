part of 'verify_otp_bloc.dart';

@immutable
sealed class VerifyOtpEvent {}

final class VerifyOtpSubmitted extends VerifyOtpEvent {
  final String phone;
  final String code;
  // ================================
  // NEW CODE START
  // ================================
  final OtpFlow flow;
  // ================================
  // NEW CODE END
  // ================================
  VerifyOtpSubmitted({
    required this.phone,
    required this.code,
    // ================================
    // NEW CODE START
    // ================================
    required this.flow,
    // ================================
    // NEW CODE END
    // ================================
  });
}