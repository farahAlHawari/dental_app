import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class BiometricRemoteDataSource {
  final DioConsumer api;
  BiometricRemoteDataSource({required this.api});

  Future<Map<String, dynamic>> setBiometricStatus({required bool enabled}) async {
    final response = await api.post(EndPoints.biometric, data: {
      "enabled": enabled,
    });
    return response as Map<String, dynamic>;
  }
}