import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class BiometricRepository {
  Future<Either<Failure, bool>> setBiometricEnabled(
    bool enabled, {
    String? phone,
    String? password,
  });

  /// Show biometric on Login: enabled + device support (no token required).
  Future<bool> canUseBiometrics();

  Future<bool> authenticate();

  /// Local biometric → secure credentials → password login → save tokens.
  Future<Either<Failure, void>> loginWithBiometrics();

  /// Legacy session probe (not used for Login entry after Feature 8).
  Future<bool> validateSession();
}
