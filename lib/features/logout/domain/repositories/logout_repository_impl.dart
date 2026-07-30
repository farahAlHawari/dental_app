// data/repositories/logout_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/logout/data/datasources/logout_data_source.dart';

import '../../domain/repositories/logout_repository.dart';

class LogoutRepositoryImpl extends LogoutRepository {
  final LogoutRemoteDataSource remoteDataSource;
  LogoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await SharedPrefs.clearTokens(); 
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }
}