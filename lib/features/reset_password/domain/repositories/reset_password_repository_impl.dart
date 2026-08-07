import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/reset_password/data/datasources/reset_password_remote_data_source.dart';
import 'package:dental_app/features/reset_password/domain/repositories/reset_password_repository.dart';

class ResetPasswordRepositoryImpl extends ResetPasswordRepository {
  final ResetPasswordRemoteDataSource remoteDataSource;
  ResetPasswordRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final result = await remoteDataSource.resetPassword(
        resetToken: resetToken,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
      ));
    }
  }
}
