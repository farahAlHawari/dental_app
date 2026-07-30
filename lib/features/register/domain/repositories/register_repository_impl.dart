import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/register/data/datasources/register_remote_data_source.dart';
import '../../domain/repositories/register_repository.dart';

class RegisterRepositoryImpl extends RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;
  RegisterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> register({
    required String phone,
    required String password,
    required String confirmPassword,
    required String language,
  }) async {
    try {
      final result = await remoteDataSource.register(
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
        language: language,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }
}