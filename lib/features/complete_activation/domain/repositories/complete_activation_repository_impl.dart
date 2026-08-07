import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/complete_activation/data/datasources/complete_activation_remote_data_source.dart';
import 'package:dental_app/features/complete_activation/domain/repositories/complete_activation_repository.dart';

class CompleteActivationRepositoryImpl extends CompleteActivationRepository {
  final CompleteActivationRemoteDataSource remoteDataSource;
  CompleteActivationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> completeActivation({
    required String temporaryToken,
    required String newPassword,
  }) async {
    try {
      final result = await remoteDataSource.completeActivation(
        temporaryToken: temporaryToken,
        newPassword: newPassword,
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
