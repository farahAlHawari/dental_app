import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';
import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/data/models/available_day.dart';
import 'package:dental_app/features/appointments/data/models/available_slot.dart';

class AppointmentAvailabilityRemoteDataSource {
  final DioConsumer api;

  AppointmentAvailabilityRemoteDataSource({required this.api});

  /// GET appointments/availability/days
  Future<List<AvailableDay>> getAvailableDays({
    required String patientId,
    required AppointmentBookingType type,
    required int month,
    required int year,
    String? treatmentSessionId,
    String? excludeAppointmentId,
  }) async {
    final query = <String, dynamic>{
      'patientId': patientId,
      'type': type.apiValue,
      'month': month,
      'year': year,
    };
    if (type == AppointmentBookingType.followUp &&
        treatmentSessionId != null &&
        treatmentSessionId.isNotEmpty) {
      query['treatmentSessionId'] = treatmentSessionId;
    }
    if (excludeAppointmentId != null && excludeAppointmentId.isNotEmpty) {
      query['excludeAppointmentId'] = excludeAppointmentId;
    }

    final response = await api.get(
      EndPoints.appointmentAvailabilityDays,
      queryParameters: query,
    );
    return _extractList(response).map(AvailableDay.fromJson).toList();
  }

  /// GET appointments/availability/slots
  Future<List<AvailableSlot>> getAvailableSlots({
    required String patientId,
    required AppointmentBookingType type,
    required String date,
    String? treatmentSessionId,
    String? excludeAppointmentId,
  }) async {
    final query = <String, dynamic>{
      'patientId': patientId,
      'type': type.apiValue,
      'date': date,
    };
    if (type == AppointmentBookingType.followUp &&
        treatmentSessionId != null &&
        treatmentSessionId.isNotEmpty) {
      query['treatmentSessionId'] = treatmentSessionId;
    }
    if (excludeAppointmentId != null && excludeAppointmentId.isNotEmpty) {
      query['excludeAppointmentId'] = excludeAppointmentId;
    }

    final response = await api.get(
      EndPoints.appointmentAvailabilitySlots,
      queryParameters: query,
    );
    return _extractList(response).map(AvailableSlot.fromJson).toList();
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
