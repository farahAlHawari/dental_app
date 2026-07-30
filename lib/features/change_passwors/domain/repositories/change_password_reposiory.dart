import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class ChangePasswordRepository {
  Future<Either<Failure, Map<String, dynamic>>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}