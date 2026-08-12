import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/promotional_gallery/data/datasources/app_content_remote_data_source.dart';
import 'package:dental_app/features/promotional_gallery/data/models/app_content.dart';
import 'package:dental_app/features/promotional_gallery/domain/repositories/app_content_repository.dart';

class AppContentRepositoryImpl extends AppContentRepository {
  final AppContentRemoteDataSource remoteDataSource;

  AppContentRepositoryImpl({required this.remoteDataSource});

  Failure _map(ServerException e) => Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
        statusCode: e.errorModel.statusCode,
      );

  @override
  Future<Either<Failure, AppContentListResult>> list({
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final result = await remoteDataSource.list(
        page: page,
        pageSize: pageSize,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppContent>> getById(String id) async {
    try {
      final result = await remoteDataSource.getById(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
