// بعد
import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/Verify_otp/data/datasources/verify_otp_remote_data_source.dart';
import '../../domain/repositories/verify_otp_repository.dart';

class VerifyOtpRepositoryImpl extends VerifyOtpRepository {
  final VerifyOtpRemoteDataSource remoteDataSource;
  VerifyOtpRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final result = await remoteDataSource.verifyOtp(phone: phone, code: code);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
      ));
    }
  }

  // ================================
  // NEW CODE START — Change Phone only
  // ================================
  @override
  Future<Either<Failure, Map<String, dynamic>>> confirmChangePhone({
    required String code,
  }) async {
    try {
      final result = await remoteDataSource.confirmChangePhone(code: code);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
      ));
    }
  }
  // ================================
  // NEW CODE END
  // ================================

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyResetOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final result = await remoteDataSource.verifyResetOtp(
        phone: phone,
        code: code,
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
