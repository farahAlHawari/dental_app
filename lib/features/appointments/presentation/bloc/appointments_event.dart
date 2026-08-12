part of 'appointments_bloc.dart';

@immutable
sealed class AppointmentsEvent {}

final class LoadAppointmentsListRequested extends AppointmentsEvent {
  final String patientId;
  LoadAppointmentsListRequested({required this.patientId});
}

final class LoadUpcomingAppointmentRequested extends AppointmentsEvent {
  final String patientId;
  LoadUpcomingAppointmentRequested({required this.patientId});
}

final class CancelAppointmentRequested extends AppointmentsEvent {
  final String appointmentId;
  final String? cancellationReason;

  CancelAppointmentRequested({
    required this.appointmentId,
    this.cancellationReason,
  });
}

final class RescheduleAppointmentRequested extends AppointmentsEvent {
  final String appointmentId;
  final String scheduledAt;

  RescheduleAppointmentRequested({
    required this.appointmentId,
    required this.scheduledAt,
  });
}

/// Before opening the date picker: loads full appointment detail when the list
/// item is missing [Appointment.treatmentSessionId] (follow-up reschedule).
final class PrepareRescheduleAppointmentRequested extends AppointmentsEvent {
  final Appointment appointment;

  PrepareRescheduleAppointmentRequested({required this.appointment});
}

final class LoadBookableSessionsRequested extends AppointmentsEvent {
  final String patientId;
  LoadBookableSessionsRequested({required this.patientId});
}

final class LoadAvailableDaysRequested extends AppointmentsEvent {
  final String patientId;
  final AppointmentBookingType type;
  final int month;
  final int year;
  final String? treatmentSessionId;
  final String? excludeAppointmentId;

  LoadAvailableDaysRequested({
    required this.patientId,
    required this.type,
    required this.month,
    required this.year,
    this.treatmentSessionId,
    this.excludeAppointmentId,
  });
}

final class LoadAvailableSlotsRequested extends AppointmentsEvent {
  final String patientId;
  final AppointmentBookingType type;
  final String date;
  final String? treatmentSessionId;
  final String? excludeAppointmentId;

  LoadAvailableSlotsRequested({
    required this.patientId,
    required this.type,
    required this.date,
    this.treatmentSessionId,
    this.excludeAppointmentId,
  });
}

final class CreateAppointmentRequested extends AppointmentsEvent {
  final String patientId;
  final AppointmentBookingType type;
  final String scheduledAt;
  final String? treatmentSessionId;
  final String? reasonForVisit;
  final String? chatbotSummary;

  CreateAppointmentRequested({
    required this.patientId,
    required this.type,
    required this.scheduledAt,
    this.treatmentSessionId,
    this.reasonForVisit,
    this.chatbotSummary,
  });
}

final class CheckInAppointmentRequested extends AppointmentsEvent {
  final String patientId;
  final String clinicCheckInCode;
  final double latitude;
  final double longitude;
  final String? appointmentId;

  CheckInAppointmentRequested({
    required this.patientId,
    required this.clinicCheckInCode,
    required this.latitude,
    required this.longitude,
    this.appointmentId,
  });
}
