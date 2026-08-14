part of 'biometric_bloc.dart';

@immutable
sealed class BiometricEvent {}

final class ToggleBiometricRequested extends BiometricEvent {
  ToggleBiometricRequested({
    required this.enabled,
    this.phone,
    this.password,
  });

  final bool enabled;

  /// Pass on enable so credentials are stored (settings should supply these).
  final String? phone;
  final String? password;
}

final class CheckBiometricAvailabilityRequested extends BiometricEvent {}

final class BiometricAuthenticateRequested extends BiometricEvent {}
