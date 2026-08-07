import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class UploadProfileImageRepository {
  Future<Either<Failure, Map<String, dynamic>>> uploadProfileImage({
    required String patientId,
    required String imagePath,
  });
}
