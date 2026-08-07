import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/features/archived_visits/data/datasources/archived_visits_remote_data_source.dart';
import 'package:dental_app/features/archived_visits/domain/repositories/archived_visits_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'archived_visits_event.dart';
part 'archived_visits_state.dart';

class ArchivedVisitsBloc
    extends Bloc<ArchivedVisitsEvent, ArchivedVisitsState> {
  final _repository = ArchivedVisitsRepositoryImpl(
    remoteDataSource: ArchivedVisitsRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  ArchivedVisitsBloc() : super(ArchivedVisitsInitial()) {
    on<LoadCompletedSessionsRequested>(_onLoadCompletedSessions);
    on<RateSessionRequested>(_onRateSession);
    on<LoadPatientHomeRequested>(_onLoadPatientHome);
    on<LoadTreatmentPlansRequested>(_onLoadTreatmentPlans);
  }

  Future<void> _onLoadCompletedSessions(
    LoadCompletedSessionsRequested event,
    Emitter<ArchivedVisitsState> emit,
  ) async {
    emit(CompletedSessionsLoading());
    final result = await _repository.getCompletedSessions(
      patientId: event.patientId,
    );
    result.fold(
      (failure) =>
          emit(CompletedSessionsFailure(errMessage: failure.errMessage)),
      (sessions) => emit(CompletedSessionsSuccess(sessions: sessions)),
    );
  }

  Future<void> _onRateSession(
    RateSessionRequested event,
    Emitter<ArchivedVisitsState> emit,
  ) async {
    emit(RateSessionLoading());
    final result = await _repository.rateSession(
      patientId: event.patientId,
      sessionId: event.sessionId,
      rating: event.rating,
    );
    result.fold(
      (failure) => emit(RateSessionFailure(errMessage: failure.errMessage)),
      (session) => emit(
        RateSessionSuccess(
          session: session,
          sessionIndex: event.sessionIndex,
        ),
      ),
    );
  }

  Future<void> _onLoadPatientHome(
    LoadPatientHomeRequested event,
    Emitter<ArchivedVisitsState> emit,
  ) async {
    emit(PatientHomeLoading());
    final result = await _repository.getPatientHome(
      patientId: event.patientId,
    );
    result.fold(
      (failure) => emit(PatientHomeFailure(errMessage: failure.errMessage)),
      (data) => emit(PatientHomeSuccess(data: data)),
    );
  }

  Future<void> _onLoadTreatmentPlans(
    LoadTreatmentPlansRequested event,
    Emitter<ArchivedVisitsState> emit,
  ) async {
    emit(TreatmentPlansLoading());
    final result = await _repository.getTreatmentPlans(
      patientId: event.patientId,
      status: event.status,
    );
    result.fold(
      (failure) => emit(TreatmentPlansFailure(errMessage: failure.errMessage)),
      (plans) => emit(TreatmentPlansSuccess(plans: plans)),
    );
  }
}
