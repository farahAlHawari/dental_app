import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

/// Forgot Password only — request OTP via phone.
abstract class ForgetPasswordRepository {
  Future<Either<Failure, Map<String, dynamic>>> forgetPassword({
    required String phone,
  });
}
