part of 'biometric_bloc.dart';

@immutable
sealed class BiometricState {}

final class BiometricInitial extends BiometricState {}

final class BiometricToggleLoading extends BiometricState {}

final class BiometricToggleSuccess extends BiometricState {
  BiometricToggleSuccess({required this.enabled});
  final bool enabled;
}

final class BiometricToggleFailure extends BiometricState {
  BiometricToggleFailure({required this.errMessage});
  final String errMessage;
}

final class BiometricAvailabilityChecked extends BiometricState {
  BiometricAvailabilityChecked({required this.available});
  final bool available;
}

final class BiometricAuthenticating extends BiometricState {}

final class BiometricAuthenticateSuccess extends BiometricState {}

final class BiometricAuthenticateFailure extends BiometricState {
  BiometricAuthenticateFailure({required this.errMessage});
  final String errMessage;
}
