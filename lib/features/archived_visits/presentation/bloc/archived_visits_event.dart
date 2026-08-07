part of 'archived_visits_bloc.dart';

@immutable
sealed class ArchivedVisitsEvent {}

final class LoadCompletedSessionsRequested extends ArchivedVisitsEvent {
  final String patientId;
  LoadCompletedSessionsRequested({required this.patientId});
}

final class RateSessionRequested extends ArchivedVisitsEvent {
  final String patientId;
  final String sessionId;
  final int rating;
  final int? sessionIndex;

  RateSessionRequested({
    required this.patientId,
    required this.sessionId,
    required this.rating,
    this.sessionIndex,
  });
}

final class LoadPatientHomeRequested extends ArchivedVisitsEvent {
  final String patientId;
  LoadPatientHomeRequested({required this.patientId});
}

final class LoadTreatmentPlansRequested extends ArchivedVisitsEvent {
  final String patientId;
  final String? status;

  LoadTreatmentPlansRequested({
    required this.patientId,
    this.status,
  });
}
