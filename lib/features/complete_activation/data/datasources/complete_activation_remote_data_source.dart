import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class CompleteActivationRemoteDataSource {
  final DioConsumer api;
  CompleteActivationRemoteDataSource({required this.api});

  Future<Map<String, dynamic>> completeActivation({
    required String temporaryToken,
    required String newPassword,
  }) async {
    final response = await api.post(
      EndPoints.completeActivation,
      data: {
        "temporaryToken": temporaryToken,
        "newPassword": newPassword,
      },
    );
    final map = response as Map<String, dynamic>;
    final data = map['data'];
    if (data is Map<String, dynamic>) return data;
    return map;
  }
}
