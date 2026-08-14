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
    // Feature 7: end local session even if the server call fails
    // (expired token, offline, 5xx). Tokens only — keep patient/prefs.
    try {
      await remoteDataSource.logout();
    } on ServerException {
      // Ignore — local logout still required.
    } catch (_) {
      // Ignore network / unexpected — local logout still required.
    }
    await SharedPrefs.clearTokens();
    return const Right(null);
  }
}