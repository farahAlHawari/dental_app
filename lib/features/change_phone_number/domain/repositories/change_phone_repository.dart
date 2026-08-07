import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class ChangePhoneRepository {
  Future<Either<Failure, Map<String, dynamic>>> startChangePhone({
    required String newPhone,
  });
}
