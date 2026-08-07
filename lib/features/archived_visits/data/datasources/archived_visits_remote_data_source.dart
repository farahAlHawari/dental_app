import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class ArchivedVisitsRemoteDataSource {
  final DioConsumer api;

  ArchivedVisitsRemoteDataSource({required this.api});

  /// GET treatment/patients/:id/treatment-sessions?status=COMPLETED
  Future<List<Map<String, dynamic>>> getCompletedSessions({
    required String patientId,
  }) async {
    final response = await api.get(
      EndPoints.treatmentSessions(patientId),
      queryParameters: {'status': 'COMPLETED'},
    );
    return _extractList(response);
  }

  /// GET treatment/patients/:id/home
  Future<Map<String, dynamic>> getPatientHome({
    required String patientId,
  }) async {
    final response = await api.get(EndPoints.treatmentPatientHome(patientId));
    return _extractMap(response);
  }

  /// POST treatment/patients/:id/treatment-sessions/:sessionId/rate
  Future<Map<String, dynamic>> rateSession({
    required String patientId,
    required String sessionId,
    required int rating,
  }) async {
    final response = await api.post(
      EndPoints.rateTreatmentSession(patientId, sessionId),
      data: {'rating': rating},
    );
    return _extractMap(response);
  }

  /// GET treatment/patients/:id/treatment-plans?status= optional
  /// Empty list is success ([]), not 404.
  Future<List<Map<String, dynamic>>> getTreatmentPlans({
    required String patientId,
    String? status,
  }) async {
    final response = await api.get(
      EndPoints.treatmentPlans(patientId),
      queryParameters: status == null || status.isEmpty
          ? null
          : {'status': status},
    );
    return _extractList(response);
  }

  Map<String, dynamic> _extractMap(dynamic response) {
    if (response is! Map) return <String, dynamic>{};
    final map = Map<String, dynamic>.from(response);
    final data = map['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return map;
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
