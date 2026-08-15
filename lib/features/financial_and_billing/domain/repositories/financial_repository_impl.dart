import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/financial_and_billing/data/datasources/financial_remote_data_source.dart';
import 'package:dental_app/features/financial_and_billing/domain/repositories/financial_repository.dart';

class FinancialRepositoryImpl extends FinancialRepository {
  final FinancialRemoteDataSource remoteDataSource;

  FinancialRepositoryImpl({required this.remoteDataSource});

  Failure _map(ServerException e) => Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
        statusCode: e.errorModel.statusCode,
      );

  @override
  Future<Either<Failure, Map<String, dynamic>>> getFinancialSummary({
    String? patientId,
    String? status,
  }) async {
    try {
      final result = await remoteDataSource.getFinancialSummary(
        patientId: patientId,
        status: status,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getInvoiceById({
    required String id,
  }) async {
    try {
      final result = await remoteDataSource.getInvoiceById(id: id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
