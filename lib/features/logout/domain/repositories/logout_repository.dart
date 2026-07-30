// domain/repositories/logout_repository.dart
import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class LogoutRepository {
  Future<Either<Failure, void>> logout();
}