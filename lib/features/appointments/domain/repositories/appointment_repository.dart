import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/data/models/appointment_list_scope.dart';
import 'package:dental_app/features/appointments/data/models/appointment_model.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, Appointment?>> getUpcoming({
    required String patientId,
  });

  Future<Either<Failure, AppointmentListResult>> list({
    required String patientId,
    required AppointmentListScope scope,
    int page = 1,
    int pageSize = 50,
  });

  Future<Either<Failure, Appointment>> getById(String id);

  Future<Either<Failure, Appointment>> create({
    required String patientId,
    required AppointmentBookingType type,
    required String scheduledAt,
    String? treatmentSessionId,
    String? reasonForVisit,
    String? chatbotSummary,
  });

  Future<Either<Failure, Appointment>> reschedule({
    required String appointmentId,
    required String scheduledAt,
  });

  Future<Either<Failure, Appointment>> cancel({
    required String appointmentId,
    String? cancellationReason,
  });

  Future<Either<Failure, Appointment>> checkIn({
    required String patientId,
    required String clinicCheckInCode,
    required double latitude,
    required double longitude,
    String? appointmentId,
  });
}
