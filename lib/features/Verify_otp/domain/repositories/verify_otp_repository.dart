// // بعد
import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class VerifyOtpRepository {
  Future<Either<Failure, Map<String, dynamic>>> verifyOtp({
    required String phone,
    required String code,
  });
}