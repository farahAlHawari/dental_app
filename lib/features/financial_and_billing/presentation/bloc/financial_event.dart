part of 'financial_bloc.dart';

@immutable
sealed class FinancialEvent {}

final class LoadFinancialSummaryRequested extends FinancialEvent {
  final String? patientId;
  final String? status;

  LoadFinancialSummaryRequested({this.patientId, this.status});
}

final class LoadInvoiceDetailsRequested extends FinancialEvent {
  final String invoiceId;

  LoadInvoiceDetailsRequested({required this.invoiceId});
}
