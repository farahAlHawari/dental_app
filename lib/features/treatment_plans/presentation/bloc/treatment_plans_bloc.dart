import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/bloc/sequential.dart';
import 'package:dental_app/features/treatment_plans/data/datasources/treatment_plan_remote_data_source.dart';
import 'package:dental_app/features/treatment_plans/data/models/invoice_status.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_invoice.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session_files.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan_status.dart';
import 'package:dental_app/features/treatment_plans/domain/repositories/treatment_plan_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'treatment_plans_event.dart';
part 'treatment_plans_state.dart';

class TreatmentPlansBloc
    extends Bloc<TreatmentPlansEvent, TreatmentPlansState> {
  final _repository = TreatmentPlanRepositoryImpl(
    remoteDataSource: TreatmentPlanRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  TreatmentPlansBloc() : super(TreatmentPlansInitial()) {
    on<LoadTreatmentPlansListRequested>(
      _onLoadList,
      transformer: sequential(),
    );
    on<LoadActiveTreatmentPlansRequested>(
      _onLoadActive,
      transformer: sequential(),
    );
    on<LoadTreatmentPlanDetailRequested>(
      _onLoadDetail,
      transformer: sequential(),
    );
    on<RatePlanSessionRequested>(
      _onRateSession,
      transformer: sequential(),
    );
    on<LoadPlanSessionFilesRequested>(
      _onLoadSessionFiles,
      transformer: sequential(),
    );
    on<LoadPlanInvoicesRequested>(
      _onLoadInvoices,
      transformer: sequential(),
    );
    on<LoadPlanInvoiceDetailRequested>(
      _onLoadInvoiceDetail,
      transformer: sequential(),
    );
  }

  Future<void> _onLoadList(
    LoadTreatmentPlansListRequested event,
    Emitter<TreatmentPlansState> emit,
  ) async {
    emit(TreatmentPlansListLoading());

    final activeResult = await _repository.list(
      patientId: event.patientId,
      status: TreatmentPlanStatus.active,
    );
    final completedResult = await _repository.list(
      patientId: event.patientId,
      status: TreatmentPlanStatus.completed,
    );

    String? activeError;
    String? completedError;
    List<TreatmentPlan> active = [];
    List<TreatmentPlan> completed = [];

    activeResult.fold(
      (f) => activeError = f.errMessage,
      (items) => active = items,
    );
    completedResult.fold(
      (f) => completedError = f.errMessage,
      (items) => completed = items,
    );

    if (activeError != null && completedError != null) {
      emit(TreatmentPlansListFailure(errMessage: activeError!));
      return;
    }

    emit(
      TreatmentPlansListSuccess(
        active: active,
        completed: completed,
        warningMessage: activeError ?? completedError,
      ),
    );
  }

  Future<void> _onLoadActive(
    LoadActiveTreatmentPlansRequested event,
    Emitter<TreatmentPlansState> emit,
  ) async {
    emit(TreatmentPlansListLoading());
    final result = await _repository.list(
      patientId: event.patientId,
      status: TreatmentPlanStatus.active,
    );
    result.fold(
      (failure) => emit(TreatmentPlansListFailure(errMessage: failure.errMessage)),
      (items) => emit(
        TreatmentPlansListSuccess(active: items, completed: const []),
      ),
    );
  }

  Future<void> _onLoadDetail(
    LoadTreatmentPlanDetailRequested event,
    Emitter<TreatmentPlansState> emit,
  ) async {
    emit(TreatmentPlanDetailLoading());
    final result = await _repository.getById(
      patientId: event.patientId,
      planId: event.planId,
    );
    result.fold(
      (failure) =>
          emit(TreatmentPlanDetailFailure(errMessage: failure.errMessage)),
      (plan) => emit(TreatmentPlanDetailSuccess(plan: plan)),
    );
  }

  Future<void> _onRateSession(
    RatePlanSessionRequested event,
    Emitter<TreatmentPlansState> emit,
  ) async {
    final rateResult = await _repository.rateSession(
      patientId: event.patientId,
      sessionId: event.sessionId,
      rating: event.rating,
    );

    final rateFailed = rateResult.fold<String?>((f) => f.errMessage, (_) => null);
    if (rateFailed != null) {
      emit(RatePlanSessionFailure(errMessage: rateFailed));
      return;
    }

    final detailResult = await _repository.getById(
      patientId: event.patientId,
      planId: event.planId,
    );
    detailResult.fold(
      (failure) =>
          emit(TreatmentPlanDetailFailure(errMessage: failure.errMessage)),
      (plan) => emit(TreatmentPlanDetailSuccess(plan: plan)),
    );
  }

  Future<void> _onLoadSessionFiles(
    LoadPlanSessionFilesRequested event,
    Emitter<TreatmentPlansState> emit,
  ) async {
    emit(PlanSessionFilesLoading(kind: event.kind));
    final result = await _repository.listSessionFiles(
      patientId: event.patientId,
      planId: event.planId,
      kind: event.kind,
    );
    result.fold(
      (failure) => emit(
        PlanSessionFilesFailure(kind: event.kind, errMessage: failure.errMessage),
      ),
      (sessions) => emit(
        PlanSessionFilesSuccess(kind: event.kind, sessions: sessions),
      ),
    );
  }

  Future<void> _onLoadInvoices(
    LoadPlanInvoicesRequested event,
    Emitter<TreatmentPlansState> emit,
  ) async {
    emit(PlanInvoicesLoading(status: event.status));
    final result = await _repository.listInvoices(
      patientId: event.patientId,
      planId: event.planId,
      status: event.status,
    );
    result.fold(
      (failure) => emit(PlanInvoicesFailure(errMessage: failure.errMessage)),
      (data) => emit(
        PlanInvoicesSuccess(
          invoices: data.items,
          summary: data.summary,
          total: data.total,
          status: event.status,
        ),
      ),
    );
  }

  Future<void> _onLoadInvoiceDetail(
    LoadPlanInvoiceDetailRequested event,
    Emitter<TreatmentPlansState> emit,
  ) async {
    emit(PlanInvoiceDetailLoading(invoiceId: event.invoiceId));
    final result = await _repository.getInvoiceById(invoiceId: event.invoiceId);
    result.fold(
      (failure) => emit(
        PlanInvoiceDetailFailure(
          invoiceId: event.invoiceId,
          errMessage: failure.errMessage,
        ),
      ),
      (invoice) => emit(PlanInvoiceDetailSuccess(invoice: invoice)),
    );
  }
}
