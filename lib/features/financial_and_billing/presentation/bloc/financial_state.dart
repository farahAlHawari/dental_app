part of 'financial_bloc.dart';

@immutable
sealed class FinancialState {}

final class FinancialInitial extends FinancialState {}

final class FinancialSummaryLoading extends FinancialState {}

final class FinancialSummarySuccess extends FinancialState {
  final Map<String, dynamic> data;
  FinancialSummarySuccess({required this.data});
}

final class FinancialSummaryFailure extends FinancialState {
  final String errMessage;
  FinancialSummaryFailure({required this.errMessage});
}

final class InvoiceDetailsLoading extends FinancialState {}

final class InvoiceDetailsSuccess extends FinancialState {
  final Map<String, dynamic> data;
  InvoiceDetailsSuccess({required this.data});
}

final class InvoiceDetailsFailure extends FinancialState {
  final String errMessage;
  InvoiceDetailsFailure({required this.errMessage});
}
