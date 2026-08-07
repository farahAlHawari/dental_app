import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class BiometricRepository {
  Future<Either<Failure, bool>> setBiometricEnabled(bool enabled);
  Future<bool> canUseBiometrics();
  Future<bool> authenticate();
  Future<bool> validateSession(); // <-- جديد
}