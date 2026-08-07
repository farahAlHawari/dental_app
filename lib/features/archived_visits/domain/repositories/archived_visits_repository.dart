import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class ArchivedVisitsRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getCompletedSessions({
    required String patientId,
  });

  Future<Either<Failure, Map<String, dynamic>>> getPatientHome({
    required String patientId,
  });

  Future<Either<Failure, Map<String, dynamic>>> rateSession({
    required String patientId,
    required String sessionId,
    required int rating,
  });

  Future<Either<Failure, List<Map<String, dynamic>>>> getTreatmentPlans({
    required String patientId,
    String? status,
  });
}
