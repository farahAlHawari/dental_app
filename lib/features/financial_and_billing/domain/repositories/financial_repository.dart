import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';

abstract class FinancialRepository {
  Future<Either<Failure, Map<String, dynamic>>> getFinancialSummary({
    String? patientId,
    String? status,
  });

  Future<Either<Failure, Map<String, dynamic>>> getInvoiceById({
    required String id,
  });
}
