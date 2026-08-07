part of 'upload_profile_image_bloc.dart';

@immutable
sealed class UploadProfileImageState {}

final class UploadProfileImageInitial extends UploadProfileImageState {}

final class UploadProfileImageLoading extends UploadProfileImageState {}

final class UploadProfileImageSuccess extends UploadProfileImageState {
  final Map<String, dynamic> patientData;

  UploadProfileImageSuccess({required this.patientData});
}

final class UploadProfileImageFailure extends UploadProfileImageState {
  final String errMessage;

  UploadProfileImageFailure({required this.errMessage});
}
