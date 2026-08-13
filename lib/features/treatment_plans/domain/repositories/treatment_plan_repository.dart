import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/treatment_plans/data/models/invoice_status.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_invoice.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session_files.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan_status.dart';

abstract class TreatmentPlanRepository {
  Future<Either<Failure, List<TreatmentPlan>>> list({
    required String patientId,
    TreatmentPlanStatus? status,
  });

  Future<Either<Failure, TreatmentPlan>> getById({
    required String patientId,
    required String planId,
  });

  Future<Either<Failure, List<PlanSessionFiles>>> listSessionFiles({
    required String patientId,
    required String planId,
    required PlanFileKind kind,
  });

  Future<Either<Failure, PlanInvoiceListResult>> listInvoices({
    required String patientId,
    required String planId,
    InvoiceStatus? status,
  });

  Future<Either<Failure, PlanInvoiceDetail>> getInvoiceById({
    required String invoiceId,
  });

  Future<Either<Failure, Map<String, dynamic>>> rateSession({
    required String patientId,
    required String sessionId,
    required int rating,
  });
}
