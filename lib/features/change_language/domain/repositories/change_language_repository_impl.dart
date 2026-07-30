import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/change_language/data/datasources/change_language_data_source.dart';
import 'package:dental_app/features/change_language/domain/repositories/change_language_repository.dart';

class ChangeLanguageRepositoryImpl extends ChangeLanguageRepository {
  final ChangeLanguageDataSource dataSource;
  ChangeLanguageRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateLanguage({
    required String language,
  }) async {
    try {
      final result = await dataSource.updateLanguage(language: language);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }
}