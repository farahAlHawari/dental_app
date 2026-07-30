import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class ChangeLanguageRepository {
  Future<Either<Failure, Map<String, dynamic>>> updateLanguage({
    required String language,
  });
}