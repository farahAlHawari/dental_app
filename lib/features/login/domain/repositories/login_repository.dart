import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class LoginRepository {
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String phone,
    required String password,
  });

  // ================================
  // NEW CODE START
  // ================================
  Future<Either<Failure, Map<String, dynamic>>> getMe();
  // ================================
  // NEW CODE END
  // ================================
}