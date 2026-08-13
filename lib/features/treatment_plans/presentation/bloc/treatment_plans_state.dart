part of 'treatment_plans_bloc.dart';

@immutable
sealed class TreatmentPlansState {}

final class TreatmentPlansInitial extends TreatmentPlansState {}

final class TreatmentPlansListLoading extends TreatmentPlansState {}

final class TreatmentPlansListSuccess extends TreatmentPlansState {
  final List<TreatmentPlan> active;
  final List<TreatmentPlan> completed;
  final String? warningMessage;

  TreatmentPlansListSuccess({
    required this.active,
    required this.completed,
    this.warningMessage,
  });
}

final class TreatmentPlansListFailure extends TreatmentPlansState {
  final String errMessage;

  TreatmentPlansListFailure({required this.errMessage});
}

final class TreatmentPlanDetailLoading extends TreatmentPlansState {}

final class TreatmentPlanDetailSuccess extends TreatmentPlansState {
  final TreatmentPlan plan;

  TreatmentPlanDetailSuccess({required this.plan});
}

final class TreatmentPlanDetailFailure extends TreatmentPlansState {
  final String errMessage;

  TreatmentPlanDetailFailure({required this.errMessage});
}

final class RatePlanSessionFailure extends TreatmentPlansState {
  final String errMessage;

  RatePlanSessionFailure({required this.errMessage});
}

final class PlanSessionFilesLoading extends TreatmentPlansState {
  final PlanFileKind kind;

  PlanSessionFilesLoading({required this.kind});
}

final class PlanSessionFilesSuccess extends TreatmentPlansState {
  final PlanFileKind kind;
  final List<PlanSessionFiles> sessions;

  PlanSessionFilesSuccess({required this.kind, required this.sessions});
}

final class PlanSessionFilesFailure extends TreatmentPlansState {
  final PlanFileKind kind;
  final String errMessage;

  PlanSessionFilesFailure({required this.kind, required this.errMessage});
}

final class PlanInvoicesLoading extends TreatmentPlansState {
  final InvoiceStatus? status;

  PlanInvoicesLoading({this.status});
}

final class PlanInvoicesSuccess extends TreatmentPlansState {
  final List<PlanInvoice> invoices;
  final PlanInvoiceSummary summary;
  final int total;
  final InvoiceStatus? status;

  PlanInvoicesSuccess({
    required this.invoices,
    required this.summary,
    required this.total,
    this.status,
  });
}

final class PlanInvoicesFailure extends TreatmentPlansState {
  final String errMessage;

  PlanInvoicesFailure({required this.errMessage});
}

final class PlanInvoiceDetailLoading extends TreatmentPlansState {
  final String invoiceId;

  PlanInvoiceDetailLoading({required this.invoiceId});
}

final class PlanInvoiceDetailSuccess extends TreatmentPlansState {
  final PlanInvoiceDetail invoice;

  PlanInvoiceDetailSuccess({required this.invoice});
}

final class PlanInvoiceDetailFailure extends TreatmentPlansState {
  final String invoiceId;
  final String errMessage;

  PlanInvoiceDetailFailure({
    required this.invoiceId,
    required this.errMessage,
  });
}
