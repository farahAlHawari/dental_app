import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';
import 'package:dental_app/features/appointments/data/models/bookable_session.dart';

class TreatmentBookingRemoteDataSource {
  final DioConsumer api;

  TreatmentBookingRemoteDataSource({required this.api});

  /// GET treatment/patients/:id/treatment-sessions/for-booking
  Future<List<BookableSession>> getSessionsForBooking({
    required String patientId,
  }) async {
    final response = await api.get(
      EndPoints.treatmentSessionsForBooking(patientId),
    );
    return _extractList(response).map(BookableSession.fromJson).toList();
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
