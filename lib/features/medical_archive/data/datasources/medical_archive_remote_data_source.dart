import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class MedicalArchiveRemoteDataSource {
  final DioConsumer api;

  MedicalArchiveRemoteDataSource({required this.api});

  /// GET treatment/patients/:id/medical-archive?type=XRAY|REPORT
  /// Empty list `[]` is success.
  Future<List<Map<String, dynamic>>> getMedicalArchive({
    required String patientId,
    required String type,
  }) async {
    final response = await api.get(
      EndPoints.medicalArchive(patientId),
      queryParameters: {'type': type},
    );
    return _extractList(response);
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is! Map) return [];
    final data = Map<String, dynamic>.from(response)['data'];
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return [];
  }
}
