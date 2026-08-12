import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/appointments/data/datasources/appointment_availability_remote_data_source.dart';
import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/data/models/available_day.dart';
import 'package:dental_app/features/appointments/data/models/available_slot.dart';
import 'package:dental_app/features/appointments/domain/repositories/appointment_availability_repository.dart';

class AppointmentAvailabilityRepositoryImpl
    extends AppointmentAvailabilityRepository {
  final AppointmentAvailabilityRemoteDataSource remoteDataSource;

  AppointmentAvailabilityRepositoryImpl({required this.remoteDataSource});

  Failure _map(ServerException e) => Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
        statusCode: e.errorModel.statusCode,
      );

  @override
  Future<Either<Failure, List<AvailableDay>>> getAvailableDays({
    required String patientId,
    required AppointmentBookingType type,
    required int month,
    required int year,
    String? treatmentSessionId,
    String? excludeAppointmentId,
  }) async {
    try {
      final result = await remoteDataSource.getAvailableDays(
        patientId: patientId,
        type: type,
        month: month,
        year: year,
        treatmentSessionId: treatmentSessionId,
        excludeAppointmentId: excludeAppointmentId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AvailableSlot>>> getAvailableSlots({
    required String patientId,
    required AppointmentBookingType type,
    required String date,
    String? treatmentSessionId,
    String? excludeAppointmentId,
  }) async {
    try {
      final result = await remoteDataSource.getAvailableSlots(
        patientId: patientId,
        type: type,
        date: date,
        treatmentSessionId: treatmentSessionId,
        excludeAppointmentId: excludeAppointmentId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
