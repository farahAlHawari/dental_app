import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class CompleteActivationRepository {
  Future<Either<Failure, Map<String, dynamic>>> completeActivation({
    required String temporaryToken,
    required String newPassword,
  });
}
