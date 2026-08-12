part of 'appointments_bloc.dart';

@immutable
sealed class AppointmentsState {}

final class AppointmentsInitial extends AppointmentsState {}

final class AppointmentsListLoading extends AppointmentsState {}

final class AppointmentsListSuccess extends AppointmentsState {
  final List<Appointment> upcoming;
  final List<Appointment> previous;

  AppointmentsListSuccess({
    required this.upcoming,
    required this.previous,
  });
}

final class AppointmentsListFailure extends AppointmentsState {
  final String errMessage;
  AppointmentsListFailure({required this.errMessage});
}

final class UpcomingAppointmentLoading extends AppointmentsState {}

final class UpcomingAppointmentSuccess extends AppointmentsState {
  final Appointment? appointment;
  UpcomingAppointmentSuccess({required this.appointment});
}

final class UpcomingAppointmentFailure extends AppointmentsState {
  final String errMessage;
  UpcomingAppointmentFailure({required this.errMessage});
}

final class CancelAppointmentLoading extends AppointmentsState {}

final class CancelAppointmentSuccess extends AppointmentsState {}

final class CancelAppointmentFailure extends AppointmentsState {
  final String errMessage;
  CancelAppointmentFailure({required this.errMessage});
}

final class RescheduleAppointmentLoading extends AppointmentsState {}

final class RescheduleAppointmentSuccess extends AppointmentsState {}

final class RescheduleAppointmentFailure extends AppointmentsState {
  final String errMessage;
  RescheduleAppointmentFailure({required this.errMessage});
}

final class ReschedulePrepareLoading extends AppointmentsState {}

final class ReschedulePreparedSuccess extends AppointmentsState {
  final Appointment appointment;

  ReschedulePreparedSuccess({required this.appointment});
}

final class ReschedulePreparedFailure extends AppointmentsState {
  final String errMessage;

  ReschedulePreparedFailure({required this.errMessage});
}

final class BookableSessionsLoading extends AppointmentsState {}

final class BookableSessionsSuccess extends AppointmentsState {
  final List<BookableSession> sessions;
  BookableSessionsSuccess({required this.sessions});
}

final class BookableSessionsFailure extends AppointmentsState {
  final String errMessage;
  BookableSessionsFailure({required this.errMessage});
}

final class AvailableDaysLoading extends AppointmentsState {}

final class AvailableDaysSuccess extends AppointmentsState {
  final List<AvailableDay> days;
  final int month;
  final int year;

  AvailableDaysSuccess({
    required this.days,
    required this.month,
    required this.year,
  });
}

final class AvailableDaysFailure extends AppointmentsState {
  final String errMessage;
  AvailableDaysFailure({required this.errMessage});
}

final class AvailableSlotsLoading extends AppointmentsState {}

final class AvailableSlotsSuccess extends AppointmentsState {
  final List<AvailableSlot> slots;
  final String date;

  AvailableSlotsSuccess({required this.slots, required this.date});
}

final class AvailableSlotsFailure extends AppointmentsState {
  final String errMessage;
  AvailableSlotsFailure({required this.errMessage});
}

final class CreateAppointmentLoading extends AppointmentsState {}

final class CreateAppointmentSuccess extends AppointmentsState {
  final Appointment appointment;
  CreateAppointmentSuccess({required this.appointment});
}

final class CreateAppointmentFailure extends AppointmentsState {
  final String errMessage;
  CreateAppointmentFailure({required this.errMessage});
}

final class CheckInAppointmentLoading extends AppointmentsState {}

final class CheckInAppointmentSuccess extends AppointmentsState {
  final Appointment appointment;
  CheckInAppointmentSuccess({required this.appointment});
}

final class CheckInAppointmentFailure extends AppointmentsState {
  final String errMessage;
  CheckInAppointmentFailure({required this.errMessage});
}
