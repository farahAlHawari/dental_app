import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/archived_visits/data/datasources/archived_visits_remote_data_source.dart';
import 'package:dental_app/features/archived_visits/domain/repositories/archived_visits_repository.dart';

class ArchivedVisitsRepositoryImpl extends ArchivedVisitsRepository {
  final ArchivedVisitsRemoteDataSource remoteDataSource;

  ArchivedVisitsRepositoryImpl({required this.remoteDataSource});

  Failure _map(ServerException e) => Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
        statusCode: e.errorModel.statusCode,
      );

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCompletedSessions({
    required String patientId,
  }) async {
    try {
      final result = await remoteDataSource.getCompletedSessions(
        patientId: patientId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPatientHome({
    required String patientId,
  }) async {
    try {
      final result = await remoteDataSource.getPatientHome(
        patientId: patientId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> rateSession({
    required String patientId,
    required String sessionId,
    required int rating,
  }) async {
    try {
      final result = await remoteDataSource.rateSession(
        patientId: patientId,
        sessionId: sessionId,
        rating: rating,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getTreatmentPlans({
    required String patientId,
    String? status,
  }) async {
    try {
      final result = await remoteDataSource.getTreatmentPlans(
        patientId: patientId,
        status: status,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
