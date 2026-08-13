import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/treatment_plans/data/datasources/treatment_plan_remote_data_source.dart';
import 'package:dental_app/features/treatment_plans/data/models/invoice_status.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_invoice.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session_files.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan_status.dart';
import 'package:dental_app/features/treatment_plans/domain/repositories/treatment_plan_repository.dart';

class TreatmentPlanRepositoryImpl extends TreatmentPlanRepository {
  final TreatmentPlanRemoteDataSource remoteDataSource;

  TreatmentPlanRepositoryImpl({required this.remoteDataSource});

  Failure _map(ServerException e) => Failure(
        errMessage: e.errorModel.errorMessage,
        code: e.errorModel.code,
        statusCode: e.errorModel.statusCode,
      );

  @override
  Future<Either<Failure, List<TreatmentPlan>>> list({
    required String patientId,
    TreatmentPlanStatus? status,
  }) async {
    try {
      final result = await remoteDataSource.list(
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
  Future<Either<Failure, TreatmentPlan>> getById({
    required String patientId,
    required String planId,
  }) async {
    try {
      final result = await remoteDataSource.getById(
        patientId: patientId,
        planId: planId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlanSessionFiles>>> listSessionFiles({
    required String patientId,
    required String planId,
    required PlanFileKind kind,
  }) async {
    try {
      final result = await remoteDataSource.listSessionFiles(
        patientId: patientId,
        planId: planId,
        kind: kind,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PlanInvoiceListResult>> listInvoices({
    required String patientId,
    required String planId,
    InvoiceStatus? status,
  }) async {
    try {
      final result = await remoteDataSource.listInvoices(
        patientId: patientId,
        planId: planId,
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
  Future<Either<Failure, PlanInvoiceDetail>> getInvoiceById({
    required String invoiceId,
  }) async {
    try {
      final result = await remoteDataSource.getInvoiceById(invoiceId: invoiceId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> rateSession({
    required String patientId,
    required String sessionId,
    required int rating,
  }) async {
    try {
      final result = await remoteDataSource.rateSession(
        patientId: patientId,
        sessionId: sessionId,
        rating: rating,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(_map(e));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
