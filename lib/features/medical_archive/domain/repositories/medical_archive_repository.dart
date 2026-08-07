import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class MedicalArchiveRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getMedicalArchive({
    required String patientId,
    required String type,
  });
}
