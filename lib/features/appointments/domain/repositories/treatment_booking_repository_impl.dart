import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/appointments/data/datasources/treatment_booking_remote_data_source.dart';
import 'package:dental_app/features/appointments/data/models/bookable_session.dart';
import 'package:dental_app/features/appointments/domain/repositories/treatment_booking_repository.dart';

class TreatmentBookingRepositoryImpl implements TreatmentBookingRepository {
  final TreatmentBookingRemoteDataSource remoteDataSource;

  TreatmentBookingRepositoryImpl({required this.remoteDataSource});

  Failure _map(ServerException e) => Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
        statusCode: e.errorModel.statusCode,
      );

  @override
  Future<Either<Failure, List<BookableSession>>> getSessionsForBooking({
    required String patientId,
  }) async {
    try {
      final sessions = await remoteDataSource.getSessionsForBooking(
        patientId: patientId,
      );
      return Right(sessions);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
