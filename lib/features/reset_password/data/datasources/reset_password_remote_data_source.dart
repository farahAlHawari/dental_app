import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class ResetPasswordRemoteDataSource {
  final DioConsumer api;
  ResetPasswordRemoteDataSource({required this.api});

  Future<Map<String, dynamic>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await api.post(
      EndPoints.resetPassword,
      data: {
        "resetToken": resetToken,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      },
    );
    final map = response as Map<String, dynamic>;
    final data = map['data'];
    if (data is Map<String, dynamic>) return data;
    return map;
  }
}
