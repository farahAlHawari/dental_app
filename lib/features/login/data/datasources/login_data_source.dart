import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class LoginDataSource {
  final DioConsumer api;
  LoginDataSource({required this.api});

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await api.post(EndPoints.login, data: {
      "phone": phone,
      "password": password,
    });
   return (response as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  // ================================
  // NEW CODE START
  // ================================
  Future<Map<String, dynamic>> getMe() async {
    final response = await api.get(EndPoints.authMe);
    return (response as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }
  // ================================
  // NEW CODE END
  // ================================
}