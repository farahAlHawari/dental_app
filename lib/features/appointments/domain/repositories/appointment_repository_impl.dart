import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/appointments/data/datasources/appointment_remote_data_source.dart';
import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/data/models/appointment_list_scope.dart';
import 'package:dental_app/features/appointments/data/models/appointment_model.dart';
import 'package:dental_app/features/appointments/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;

  AppointmentRepositoryImpl({required this.remoteDataSource});

  Failure _map(ServerException e) => Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
        statusCode: e.errorModel.statusCode,
      );

  @override
  Future<Either<Failure, Appointment?>> getUpcoming({
    required String patientId,
  }) async {
    try {
      final result = await remoteDataSource.getUpcoming(patientId: patientId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentListResult>> list({
    required String patientId,
    required AppointmentListScope scope,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final result = await remoteDataSource.list(
        patientId: patientId,
        scope: scope,
        page: page,
        pageSize: pageSize,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Appointment>> getById(String id) async {
    try {
      final result = await remoteDataSource.getById(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Appointment>> create({
    required String patientId,
    required AppointmentBookingType type,
    required String scheduledAt,
    String? treatmentSessionId,
    String? reasonForVisit,
    String? chatbotSummary,
  }) async {
    try {
      final result = await remoteDataSource.create(
        patientId: patientId,
        type: type,
        scheduledAt: scheduledAt,
        treatmentSessionId: treatmentSessionId,
        reasonForVisit: reasonForVisit,
        chatbotSummary: chatbotSummary,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Appointment>> reschedule({
    required String appointmentId,
    required String scheduledAt,
  }) async {
    try {
      final result = await remoteDataSource.reschedule(
        appointmentId: appointmentId,
        scheduledAt: scheduledAt,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Appointment>> cancel({
    required String appointmentId,
    String? cancellationReason,
  }) async {
    try {
      final result = await remoteDataSource.cancel(
        appointmentId: appointmentId,
        cancellationReason: cancellationReason,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Appointment>> checkIn({
    required String patientId,
    required String clinicCheckInCode,
    required double latitude,
    required double longitude,
    String? appointmentId,
  }) async {
    try {
      final result = await remoteDataSource.checkIn(
        patientId: patientId,
        clinicCheckInCode: clinicCheckInCode,
        latitude: latitude,
        longitude: longitude,
        appointmentId: appointmentId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
