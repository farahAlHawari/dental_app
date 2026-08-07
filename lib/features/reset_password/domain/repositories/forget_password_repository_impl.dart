import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/reset_password/data/datasources/forget_password_remote_data_source.dart';
import 'package:dental_app/features/reset_password/domain/repositories/forget_password_repository.dart';

class ForgetPasswordRepositoryImpl extends ForgetPasswordRepository {
  final ForgetPasswordRemoteDataSource remoteDataSource;
  ForgetPasswordRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> forgetPassword({
    required String phone,
  }) async {
    try {
      final result = await remoteDataSource.forgetPassword(phone: phone);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
      ));
    }
  }
}
