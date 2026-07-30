import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class LogoutRemoteDataSource {
  final DioConsumer api;
  LogoutRemoteDataSource({required this.api});

  Future<void> logout() async {
    await api.post(EndPoints.logout);
  }
}