part of 'archived_visits_bloc.dart';

@immutable
sealed class ArchivedVisitsState {}

final class ArchivedVisitsInitial extends ArchivedVisitsState {}

final class CompletedSessionsLoading extends ArchivedVisitsState {}

final class CompletedSessionsSuccess extends ArchivedVisitsState {
  final List<Map<String, dynamic>> sessions;
  CompletedSessionsSuccess({required this.sessions});
}

final class CompletedSessionsFailure extends ArchivedVisitsState {
  final String errMessage;
  CompletedSessionsFailure({required this.errMessage});
}

final class RateSessionLoading extends ArchivedVisitsState {}

final class RateSessionSuccess extends ArchivedVisitsState {
  final Map<String, dynamic> session;
  final int? sessionIndex;
  RateSessionSuccess({required this.session, this.sessionIndex});
}

final class RateSessionFailure extends ArchivedVisitsState {
  final String errMessage;
  RateSessionFailure({required this.errMessage});
}

final class PatientHomeLoading extends ArchivedVisitsState {}

final class PatientHomeSuccess extends ArchivedVisitsState {
  final Map<String, dynamic> data;
  PatientHomeSuccess({required this.data});
}

final class PatientHomeFailure extends ArchivedVisitsState {
  final String errMessage;
  PatientHomeFailure({required this.errMessage});
}

final class TreatmentPlansLoading extends ArchivedVisitsState {}

final class TreatmentPlansSuccess extends ArchivedVisitsState {
  final List<Map<String, dynamic>> plans;
  TreatmentPlansSuccess({required this.plans});
}

final class TreatmentPlansFailure extends ArchivedVisitsState {
  final String errMessage;
  TreatmentPlansFailure({required this.errMessage});
}
