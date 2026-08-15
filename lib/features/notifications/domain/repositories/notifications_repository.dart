import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/notifications/data/datasources/notifications_remote_data_source.dart';

class NotificationsRepository {
  NotificationsRepository({required this.remoteDataSource});

  final NotificationsRemoteDataSource remoteDataSource;

  Future<Either<Failure, Map<String, dynamic>>> getNotifications({
    bool? isRead,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final data = await remoteDataSource.getNotifications(
        isRead: isRead,
        page: page,
        pageSize: pageSize,
      );
      return Right(data);
    } on ServerException catch (e) {
      return Left(
        Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.statusCode,
        ),
      );
    }
  }

  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await remoteDataSource.getUnreadCount();
      return Right(count);
    } on ServerException catch (e) {
      return Left(
        Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.statusCode,
        ),
      );
    }
  }

  Future<Either<Failure, int>> markAllRead() async {
    try {
      final count = await remoteDataSource.markAllRead();
      return Right(count);
    } on ServerException catch (e) {
      return Left(
        Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.statusCode,
        ),
      );
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> markOneRead({
    required String id,
  }) async {
    try {
      final data = await remoteDataSource.markOneRead(id: id);
      return Right(data);
    } on ServerException catch (e) {
      return Left(
        Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.statusCode,
        ),
      );
    }
  }
}
