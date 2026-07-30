import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class ChangePasswordDataSource {
  final DioConsumer api;
  ChangePasswordDataSource({required this.api});

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await api.post(EndPoints.changePassword, data: {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
    });
    return response as Map<String, dynamic>;
  }
}