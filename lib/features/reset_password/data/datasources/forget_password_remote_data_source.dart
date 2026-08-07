import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

/// Forgot Password only — POST /auth/forgot-password
class ForgetPasswordRemoteDataSource {
  final DioConsumer api;
  ForgetPasswordRemoteDataSource({required this.api});

  Future<Map<String, dynamic>> forgetPassword({required String phone}) async {
    final response = await api.post(
      EndPoints.forgotPassword,
      data: {"phone": phone},
    );
    final map = response as Map<String, dynamic>;
    final data = map['data'];
    if (data is Map<String, dynamic>) return data;
    return map;
  }
}
