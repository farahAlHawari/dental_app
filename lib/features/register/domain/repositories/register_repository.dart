import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class RegisterRepository {
  Future<Either<Failure, Map<String, dynamic>>> register({
    required String phone,
    required String password,
    required String confirmPassword,
    required String language,
  });
}