part of 'treatment_plans_bloc.dart';

@immutable
sealed class TreatmentPlansEvent {}

final class LoadTreatmentPlansListRequested extends TreatmentPlansEvent {
  final String patientId;

  LoadTreatmentPlansListRequested({required this.patientId});
}

final class LoadActiveTreatmentPlansRequested extends TreatmentPlansEvent {
  final String patientId;

  LoadActiveTreatmentPlansRequested({required this.patientId});
}

final class LoadTreatmentPlanDetailRequested extends TreatmentPlansEvent {
  final String patientId;
  final String planId;

  LoadTreatmentPlanDetailRequested({
    required this.patientId,
    required this.planId,
  });
}

final class RatePlanSessionRequested extends TreatmentPlansEvent {
  final String patientId;
  final String planId;
  final String sessionId;
  final int rating;

  RatePlanSessionRequested({
    required this.patientId,
    required this.planId,
    required this.sessionId,
    required this.rating,
  });
}

final class LoadPlanSessionFilesRequested extends TreatmentPlansEvent {
  final String patientId;
  final String planId;
  final PlanFileKind kind;

  LoadPlanSessionFilesRequested({
    required this.patientId,
    required this.planId,
    required this.kind,
  });
}

final class LoadPlanInvoicesRequested extends TreatmentPlansEvent {
  final String patientId;
  final String planId;
  final InvoiceStatus? status;

  LoadPlanInvoicesRequested({
    required this.patientId,
    required this.planId,
    this.status,
  });
}

final class LoadPlanInvoiceDetailRequested extends TreatmentPlansEvent {
  final String invoiceId;

  LoadPlanInvoiceDetailRequested({required this.invoiceId});
}
