import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/appointments/data/models/bookable_session.dart';

abstract class TreatmentBookingRepository {
  Future<Either<Failure, List<BookableSession>>> getSessionsForBooking({
    required String patientId,
  });
}
