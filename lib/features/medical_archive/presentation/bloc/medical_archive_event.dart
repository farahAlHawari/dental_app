part of 'medical_archive_bloc.dart';

@immutable
sealed class MedicalArchiveEvent {}

final class LoadMedicalArchiveRequested extends MedicalArchiveEvent {
  final String patientId;
  final String type;

  LoadMedicalArchiveRequested({
    required this.patientId,
    required this.type,
  });
}
