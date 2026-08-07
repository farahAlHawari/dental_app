import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class ResetPasswordRepository {
  Future<Either<Failure, Map<String, dynamic>>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  });
}
