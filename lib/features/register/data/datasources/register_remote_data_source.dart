import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class RegisterRemoteDataSource {
  final DioConsumer api;
  RegisterRemoteDataSource({required this.api});

  Future<Map<String, dynamic>> register({
    required String phone,
    required String password,
    required String confirmPassword,
    required String language,
  }) async {
    final response = await api.post(EndPoints.register, data: {
      "phone": phone,
      "password": password,
      "confirmPassword": confirmPassword,
      "language": language,
    });
    return (response as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }
}