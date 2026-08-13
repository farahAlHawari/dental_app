import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/bloc/sequential.dart';
import 'package:dental_app/features/appointments/data/datasources/appointment_availability_remote_data_source.dart';
import 'package:dental_app/features/appointments/data/datasources/appointment_remote_data_source.dart';
import 'package:dental_app/features/appointments/data/datasources/treatment_booking_remote_data_source.dart';
import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/data/models/appointment_list_scope.dart';
import 'package:dental_app/features/appointments/data/models/appointment_model.dart';
import 'package:dental_app/features/appointments/data/models/appointment_status.dart';
import 'package:dental_app/features/appointments/data/models/bookable_session.dart';
import 'package:dental_app/features/appointments/data/models/available_day.dart';
import 'package:dental_app/features/appointments/data/models/available_slot.dart';
import 'package:dental_app/features/appointments/domain/repositories/appointment_availability_repository_impl.dart';
import 'package:dental_app/features/appointments/domain/repositories/appointment_repository_impl.dart';
import 'package:dental_app/features/appointments/domain/repositories/treatment_booking_repository_impl.dart';
import 'package:dental_app/features/appointments/presentation/utils/appointment_error_messages.dart';
import 'package:dental_app/features/appointments/presentation/utils/appointment_failure_extension.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'appointments_event.dart';
part 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  static final _api = DioConsumer(dio: Dio());

  final _repository = AppointmentRepositoryImpl(
    remoteDataSource: AppointmentRemoteDataSource(api: _api),
  );

  final _availabilityRepository = AppointmentAvailabilityRepositoryImpl(
    remoteDataSource: AppointmentAvailabilityRemoteDataSource(api: _api),
  );

  final _treatmentBookingRepository = TreatmentBookingRepositoryImpl(
    remoteDataSource: TreatmentBookingRemoteDataSource(api: _api),
  );

  AppointmentsBloc() : super(AppointmentsInitial()) {
    on<LoadAppointmentsListRequested>(_onLoadList, transformer: sequential());
    on<LoadUpcomingAppointmentRequested>(
      _onLoadUpcoming,
      transformer: sequential(),
    );
    on<CancelAppointmentRequested>(_onCancel, transformer: sequential());
    on<RescheduleAppointmentRequested>(
      _onReschedule,
      transformer: sequential(),
    );
    on<PrepareRescheduleAppointmentRequested>(
      _onPrepareReschedule,
      transformer: sequential(),
    );
    on<LoadBookableSessionsRequested>(
      _onLoadBookableSessions,
      transformer: sequential(),
    );
    on<LoadAvailableDaysRequested>(
      _onLoadAvailableDays,
      transformer: sequential(),
    );
    on<LoadAvailableSlotsRequested>(
      _onLoadAvailableSlots,
      transformer: sequential(),
    );
    on<CreateAppointmentRequested>(
      _onCreateAppointment,
      transformer: sequential(),
    );
    on<CheckInAppointmentRequested>(_onCheckIn, transformer: sequential());
    on<LoadActiveConsultationGateRequested>(
      _onLoadActiveConsultationGate,
      transformer: sequential(),
    );
  }

  Future<void> _onLoadList(
    LoadAppointmentsListRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentsListLoading());

    final upcomingResult = await _repository.list(
      patientId: event.patientId,
      scope: AppointmentListScope.upcoming,
    );
    final pastResult = await _repository.list(
      patientId: event.patientId,
      scope: AppointmentListScope.past,
    );

    String? upcomingError;
    String? pastError;
    List<Appointment> upcoming = [];
    List<Appointment> previous = [];

    upcomingResult.fold(
      (f) => upcomingError = f.displayMessage,
      (r) => upcoming = r.items,
    );
    pastResult.fold(
      (f) => pastError = f.displayMessage,
      (r) => previous = r.items,
    );

    if (upcomingError != null && pastError != null) {
      emit(AppointmentsListFailure(errMessage: upcomingError!));
      return;
    }

    emit(
      AppointmentsListSuccess(
        upcoming: upcoming,
        previous: previous,
        warningMessage: upcomingError ?? pastError,
      ),
    );
  }

  Future<void> _onLoadUpcoming(
    LoadUpcomingAppointmentRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(UpcomingAppointmentLoading());
    final result = await _repository.getUpcoming(patientId: event.patientId);
    result.fold(
      (f) => emit(UpcomingAppointmentFailure(errMessage: f.displayMessage)),
      (appointment) =>
          emit(UpcomingAppointmentSuccess(appointment: appointment)),
    );
  }

  Future<void> _onCancel(
    CancelAppointmentRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(CancelAppointmentLoading());
    final result = await _repository.cancel(
      appointmentId: event.appointmentId,
      cancellationReason: event.cancellationReason,
    );
    result.fold(
      (f) => emit(CancelAppointmentFailure(errMessage: f.displayMessage)),
      (_) => emit(CancelAppointmentSuccess()),
    );
  }

  Future<void> _onReschedule(
    RescheduleAppointmentRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(RescheduleAppointmentLoading());
    final result = await _repository.reschedule(
      appointmentId: event.appointmentId,
      scheduledAt: event.scheduledAt,
    );
    result.fold(
      (f) => emit(RescheduleAppointmentFailure(errMessage: f.displayMessage)),
      (_) => emit(RescheduleAppointmentSuccess()),
    );
  }

  Future<void> _onPrepareReschedule(
    PrepareRescheduleAppointmentRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    final listItem = event.appointment;
    final hasSessionId = listItem.treatmentSessionId != null &&
        listItem.treatmentSessionId!.trim().isNotEmpty;

    if (hasSessionId) {
      emit(ReschedulePreparedSuccess(appointment: listItem));
      return;
    }

    emit(ReschedulePrepareLoading());
    final result = await _repository.getById(listItem.id);
    result.fold(
      (f) => emit(ReschedulePreparedFailure(errMessage: f.displayMessage)),
      (detail) {
        final bookingType =
            detail.bookingType ?? listItem.bookingType;
        final sessionId = detail.treatmentSessionId?.trim();
        final isFollowUp = bookingType == AppointmentBookingType.followUp;

        if (isFollowUp && (sessionId == null || sessionId.isEmpty)) {
          emit(
            ReschedulePreparedFailure(
              errMessage: resolveAppointmentFailure(
                code: 'TREATMENT_SESSION_REQUIRED',
                fallback:
                    'A treatment session is required for follow-up booking.',
              ),
            ),
          );
          return;
        }

        emit(
          ReschedulePreparedSuccess(
            appointment: listItem.copyWith(
              treatmentSessionId: detail.treatmentSessionId,
              bookingType: bookingType,
              reasonForVisit: detail.reasonForVisit ?? listItem.reasonForVisit,
              durationMinutes:
                  detail.durationMinutes ?? listItem.durationMinutes,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onLoadBookableSessions(
    LoadBookableSessionsRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(BookableSessionsLoading());
    final result = await _treatmentBookingRepository.getSessionsForBooking(
      patientId: event.patientId,
    );
    result.fold(
      (f) => emit(BookableSessionsFailure(errMessage: f.displayMessage)),
      (sessions) {
        final sorted = List<BookableSession>.from(sessions)
          ..sort((a, b) {
            if (a.canBook != b.canBook) {
              return a.canBook ? -1 : 1;
            }
            if (a.treatmentPlanId != b.treatmentPlanId) {
              return a.treatmentPlanId.compareTo(b.treatmentPlanId);
            }
            return a.sessionOrder.compareTo(b.sessionOrder);
          });
        emit(BookableSessionsSuccess(sessions: sorted));
      },
    );
  }

  Future<void> _onLoadAvailableDays(
    LoadAvailableDaysRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AvailableDaysLoading());
    final result = await _availabilityRepository.getAvailableDays(
      patientId: event.patientId,
      type: event.type,
      month: event.month,
      year: event.year,
      treatmentSessionId: event.treatmentSessionId,
      excludeAppointmentId: event.excludeAppointmentId,
    );
    result.fold(
      (f) => emit(AvailableDaysFailure(errMessage: f.displayMessage)),
      (days) => emit(
        AvailableDaysSuccess(
          days: days,
          month: event.month,
          year: event.year,
        ),
      ),
    );
  }

  Future<void> _onLoadAvailableSlots(
    LoadAvailableSlotsRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AvailableSlotsLoading());
    final result = await _availabilityRepository.getAvailableSlots(
      patientId: event.patientId,
      type: event.type,
      date: event.date,
      treatmentSessionId: event.treatmentSessionId,
      excludeAppointmentId: event.excludeAppointmentId,
    );
    result.fold(
      (f) => emit(AvailableSlotsFailure(errMessage: f.displayMessage)),
      (slots) => emit(
        AvailableSlotsSuccess(slots: slots, date: event.date),
      ),
    );
  }

  Future<void> _onCreateAppointment(
    CreateAppointmentRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(CreateAppointmentLoading());
    final result = await _repository.create(
      patientId: event.patientId,
      type: event.type,
      scheduledAt: event.scheduledAt,
      treatmentSessionId: event.treatmentSessionId,
      reasonForVisit: event.reasonForVisit,
      chatbotSummary: event.chatbotSummary,
    );
    result.fold(
      (f) => emit(CreateAppointmentFailure(errMessage: f.displayMessage)),
      (appointment) => emit(CreateAppointmentSuccess(appointment: appointment)),
    );
  }

  Future<void> _onCheckIn(
    CheckInAppointmentRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(CheckInAppointmentLoading());
    final result = await _repository.checkIn(
      patientId: event.patientId,
      clinicCheckInCode: event.clinicCheckInCode,
      latitude: event.latitude,
      longitude: event.longitude,
      appointmentId: event.appointmentId,
    );
    result.fold(
      (f) => emit(CheckInAppointmentFailure(errMessage: f.displayMessage)),
      (appointment) =>
          emit(CheckInAppointmentSuccess(appointment: appointment)),
    );
  }

  Future<void> _onLoadActiveConsultationGate(
    LoadActiveConsultationGateRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(ActiveConsultationGateLoading());
    final result = await _repository.list(
      patientId: event.patientId,
      scope: AppointmentListScope.upcoming,
    );
    result.fold(
      (f) => emit(ActiveConsultationGateFailure(errMessage: f.displayMessage)),
      (data) {
        Appointment? active;
        for (final item in data.items) {
          if (item.bookingType == AppointmentBookingType.consultation &&
              item.status.isUpcoming) {
            active = item;
            break;
          }
        }
        emit(
          ActiveConsultationGateReady(
            consultationBlocked: active != null,
            activeConsultation: active,
          ),
        );
      },
    );
  }
}
