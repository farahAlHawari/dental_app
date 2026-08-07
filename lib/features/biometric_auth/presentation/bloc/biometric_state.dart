part of 'biometric_bloc.dart';

@immutable
sealed class BiometricState {}

final class BiometricInitial extends BiometricState {}

// حالات السويتش بصفحة الإعدادات
final class BiometricToggleLoading extends BiometricState {}

final class BiometricToggleSuccess extends BiometricState {
  final bool enabled;
  BiometricToggleSuccess({required this.enabled});
}

final class BiometricToggleFailure extends BiometricState {
  final String errMessage;
  BiometricToggleFailure({required this.errMessage});
}

// حالة فحص التوفر بصفحة اللوغين
final class BiometricAvailabilityChecked extends BiometricState {
  final bool available;
  BiometricAvailabilityChecked({required this.available});
}

// حالات عملية المصادقة الفعلية بصفحة اللوغين
final class BiometricAuthenticating extends BiometricState {}
final class BiometricAuthenticateSuccess extends BiometricState {}
final class BiometricAuthenticateFailure extends BiometricState {}