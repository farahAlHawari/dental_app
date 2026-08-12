import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/data/models/available_day.dart';
import 'package:dental_app/features/appointments/data/models/available_slot.dart';

abstract class AppointmentAvailabilityRepository {
  Future<Either<Failure, List<AvailableDay>>> getAvailableDays({
    required String patientId,
    required AppointmentBookingType type,
    required int month,
    required int year,
    String? treatmentSessionId,
    String? excludeAppointmentId,
  });

  Future<Either<Failure, List<AvailableSlot>>> getAvailableSlots({
    required String patientId,
    required AppointmentBookingType type,
    required String date,
    String? treatmentSessionId,
    String? excludeAppointmentId,
  });
}
