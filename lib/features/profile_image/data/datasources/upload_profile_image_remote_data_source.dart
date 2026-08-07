import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';
import 'package:dental_app/core/errors/error_model.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dio/dio.dart';

class UploadProfileImageRemoteDataSource {
  final DioConsumer api;

  UploadProfileImageRemoteDataSource({required this.api});

  /// PATCH patients/{id}/profile-image as multipart/form-data.
  /// Field name must be `file` (per Swagger / backend FileInterceptor).
  Future<Map<String, dynamic>> uploadProfileImage({
    required String patientId,
    required String imagePath,
  }) async {
    final fileName = imagePath.split(RegExp(r'[\\/]')).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imagePath,
        filename: fileName.isNotEmpty ? fileName : 'profile.jpg',
      ),
    });

    final response = await api.patch(
      EndPoints.patientProfileImage(patientId),
      data: formData,
    );

    // ================================
    // MODIFIED — safe parse (avoid cast crash on null / odd shapes)
    // ================================
    if (response == null) {
      // Some servers return 200/204 with empty body after upload.
      return <String, dynamic>{};
    }
    if (response is! Map) {
      throw ServerException(
        errorModel: ErrorModel(
          statusCode: 500,
          errorMessage: 'Unexpected profile image response: $response',
        ),
      );
    }

    final map = Map<String, dynamic>.from(response);
    final data = map['data'];
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return map;
  }
}
