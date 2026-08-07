import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/login/data/datasources/login_data_source.dart';
import 'package:dental_app/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginDataSource loginDataSource;
  LoginRepositoryImpl({required this.loginDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final result = await loginDataSource.login(
        phone: phone,
        password: password,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(
        Failure(
          errMessage: e.errorModel.errorMessage,
          code: e.errorModel.code,
          statusCode: e.errorModel.statusCode,
        ),
      );
    }
  }

  // ================================
  // NEW CODE START
  // ================================
  @override
  Future<Either<Failure, Map<String, dynamic>>> getMe() async {
    try {
      final result = await loginDataSource.getMe();
      return Right(result);
    } on ServerException catch (e) {
      return Left(
        Failure(
          errMessage: e.errorModel.errorMessage,
          code: e.errorModel.code,
          statusCode: e.errorModel.statusCode,
        ),
      );
    }
  }
  // ================================
  // NEW CODE END
  // ================================
}