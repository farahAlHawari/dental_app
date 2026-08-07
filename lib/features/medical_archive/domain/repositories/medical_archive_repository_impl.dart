import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/medical_archive/data/datasources/medical_archive_remote_data_source.dart';
import 'package:dental_app/features/medical_archive/domain/repositories/medical_archive_repository.dart';

class MedicalArchiveRepositoryImpl extends MedicalArchiveRepository {
  final MedicalArchiveRemoteDataSource remoteDataSource;

  MedicalArchiveRepositoryImpl({required this.remoteDataSource});

  Failure _map(ServerException e) => Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
        statusCode: e.errorModel.statusCode,
      );

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getMedicalArchive({
    required String patientId,
    required String type,
  }) async {
    try {
      final result = await remoteDataSource.getMedicalArchive(
        patientId: patientId,
        type: type,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
