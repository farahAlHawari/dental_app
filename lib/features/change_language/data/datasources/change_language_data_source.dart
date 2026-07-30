import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class ChangeLanguageDataSource {
  final DioConsumer api;
  ChangeLanguageDataSource({required this.api});

  Future<Map<String, dynamic>> updateLanguage({
    required String language,
  }) async {
    final response = await api.patch(EndPoints.language, data: {
      "language": language,
    });
    return (response as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }
}