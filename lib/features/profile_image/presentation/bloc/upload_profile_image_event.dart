part of 'upload_profile_image_bloc.dart';

@immutable
sealed class UploadProfileImageEvent {}

final class UploadProfileImageRequested extends UploadProfileImageEvent {
  final String patientId;
  final String imagePath;

  UploadProfileImageRequested({
    required this.patientId,
    required this.imagePath,
  });
}
