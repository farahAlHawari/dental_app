// // بعد
import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class VerifyOtpRepository {
  Future<Either<Failure, Map<String, dynamic>>> verifyOtp({
    required String phone,
    required String code,
  });

  // ================================
  // NEW CODE START — Change Phone only
  // ================================
  Future<Either<Failure, Map<String, dynamic>>> confirmChangePhone({
    required String code,
  });
  // ================================
  // NEW CODE END
  // ================================

  Future<Either<Failure, Map<String, dynamic>>> verifyResetOtp({
    required String phone,
    required String code,
  });
}