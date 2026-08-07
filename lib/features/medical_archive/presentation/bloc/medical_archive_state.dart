part of 'medical_archive_bloc.dart';

@immutable
sealed class MedicalArchiveState {}

final class MedicalArchiveInitial extends MedicalArchiveState {}

final class MedicalArchiveLoading extends MedicalArchiveState {
  final String type;
  MedicalArchiveLoading({required this.type});
}

final class MedicalArchiveSuccess extends MedicalArchiveState {
  final String type;
  final List<Map<String, dynamic>> items;

  MedicalArchiveSuccess({required this.type, required this.items});
}

final class MedicalArchiveFailure extends MedicalArchiveState {
  final String type;
  final String errMessage;

  MedicalArchiveFailure({required this.type, required this.errMessage});
}
