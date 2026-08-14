import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/features/financial_and_billing/data/datasources/financial_remote_data_source.dart';
import 'package:dental_app/features/financial_and_billing/domain/repositories/financial_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'financial_event.dart';
part 'financial_state.dart';

class FinancialBloc extends Bloc<FinancialEvent, FinancialState> {
  final _repository = FinancialRepositoryImpl(
    remoteDataSource: FinancialRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  FinancialBloc() : super(FinancialInitial()) {
    on<LoadFinancialSummaryRequested>(_onLoadSummary);
    on<LoadInvoiceDetailsRequested>(_onLoadInvoice);
  }

  Future<void> _onLoadSummary(
    LoadFinancialSummaryRequested event,
    Emitter<FinancialState> emit,
  ) async {
    emit(FinancialSummaryLoading());
    final result = await _repository.getFinancialSummary(
      patientId: event.patientId,
      status: event.status,
    );
    result.fold(
      (failure) => emit(
        FinancialSummaryFailure(errMessage: failure.errMessage),
      ),
      (data) => emit(FinancialSummarySuccess(data: data)),
    );
  }

  Future<void> _onLoadInvoice(
    LoadInvoiceDetailsRequested event,
    Emitter<FinancialState> emit,
  ) async {
    emit(InvoiceDetailsLoading());
    final result = await _repository.getInvoiceById(id: event.invoiceId);
    result.fold(
      (failure) => emit(
        InvoiceDetailsFailure(errMessage: failure.errMessage),
      ),
      (data) => emit(InvoiceDetailsSuccess(data: data)),
    );
  }
}
