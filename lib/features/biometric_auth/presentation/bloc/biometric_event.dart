part of 'biometric_bloc.dart';

@immutable
sealed class BiometricEvent {}

final class ToggleBiometricRequested extends BiometricEvent {
  final bool enabled;
  ToggleBiometricRequested({required this.enabled});
}

final class CheckBiometricAvailabilityRequested extends BiometricEvent {}

final class BiometricAuthenticateRequested extends BiometricEvent {}