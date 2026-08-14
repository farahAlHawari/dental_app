import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class DeviceTokenRemoteDataSource {
  DeviceTokenRemoteDataSource({required this.api});

  final DioConsumer api;

  /// POST device-tokens — register FCM for push.
  Future<Map<String, dynamic>> registerToken({
    required String token,
    required String platform,
  }) async {
    final response = await api.post(
      EndPoints.deviceTokens,
      data: {
        'token': token,
        'platform': platform,
      },
    );
    return _extractMap(response);
  }

  /// DELETE device-tokens — unregister FCM when session ends.
  Future<void> deleteToken({required String token}) async {
    await api.delete(
      EndPoints.deviceTokens,
      data: {'token': token},
    );
  }

  Map<String, dynamic> _extractMap(dynamic response) {
    if (response is! Map) return {};
    final data = Map<String, dynamic>.from(response)['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }
}
