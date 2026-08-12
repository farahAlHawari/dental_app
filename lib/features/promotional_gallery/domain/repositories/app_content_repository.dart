import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/promotional_gallery/data/models/app_content.dart';

abstract class AppContentRepository {
  Future<Either<Failure, AppContentListResult>> list({
    int page,
    int pageSize,
  });

  Future<Either<Failure, AppContent>> getById(String id);
}
