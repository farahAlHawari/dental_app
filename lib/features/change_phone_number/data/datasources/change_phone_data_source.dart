import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

/// Uses [DioConsumer] so Authorization Bearer token is attached
/// the same way as other protected APIs (change-password, language, ...).
class ChangePhoneDataSource {
  final DioConsumer api;
  ChangePhoneDataSource({required this.api});

  Future<Map<String, dynamic>> startChangePhone({
    required String newPhone,
  }) async {
    final response = await api.post(
      EndPoints.changePhoneStart,
      data: {"newPhone": newPhone},
    );
    final map = response as Map<String, dynamic>;
    final data = map['data'];
    if (data is Map<String, dynamic>) return data;
    return map;
  }
}
