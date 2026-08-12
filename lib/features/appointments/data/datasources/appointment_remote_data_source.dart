import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';
import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/data/models/appointment_list_scope.dart';
import 'package:dental_app/features/appointments/data/models/appointment_model.dart';

class AppointmentRemoteDataSource {
  final DioConsumer api;

  AppointmentRemoteDataSource({required this.api});

  /// GET appointments/upcoming?patientId=
  /// يرجع null إذا ما في موعد قادم.
  Future<Appointment?> getUpcoming({required String patientId}) async {
    final response = await api.get(
      EndPoints.appointmentsUpcoming,
      queryParameters: {'patientId': patientId},
    );
    final data = _extractData(response);
    if (data == null) return null;
    return Appointment.fromJson(data);
  }

  /// GET appointments?patientId=&scope=UPCOMING|PAST
  Future<AppointmentListResult> list({
    required String patientId,
    required AppointmentListScope scope,
    int page = 1,
    int pageSize = 50,
  }) async {
    final response = await api.get(
      EndPoints.appointments,
      queryParameters: {
        'patientId': patientId,
        'scope': scope.apiValue,
        'page': page,
        'pageSize': pageSize,
      },
    );
    final data = _extractData(response);
    if (data == null) {
      return const AppointmentListResult(items: [], total: 0);
    }
    final itemsRaw = data['items'];
    final items = itemsRaw is List
        ? itemsRaw
            .whereType<Map>()
            .map((e) => Appointment.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <Appointment>[];
    final total = data['total'] is int
        ? data['total'] as int
        : int.tryParse('${data['total']}') ?? items.length;
    return AppointmentListResult(items: items, total: total);
  }

  /// GET appointments/:id
  Future<Appointment> getById(String id) async {
    final response = await api.get(EndPoints.appointmentById(id));
    final data = _extractData(response);
    if (data == null) {
      throw StateError('Empty appointment response');
    }
    return Appointment.fromJson(data);
  }

  /// POST appointments
  Future<Appointment> create({
    required String patientId,
    required AppointmentBookingType type,
    required String scheduledAt,
    String? treatmentSessionId,
    String? reasonForVisit,
    String? chatbotSummary,
  }) async {
    final body = <String, dynamic>{
      'patientId': int.parse(patientId),
      'type': type.apiValue,
      'scheduledAt': scheduledAt,
    };
    if (type == AppointmentBookingType.followUp &&
        treatmentSessionId != null &&
        treatmentSessionId.isNotEmpty) {
      body['treatmentSessionId'] = int.parse(treatmentSessionId);
    }
    if (reasonForVisit != null && reasonForVisit.trim().isNotEmpty) {
      body['reasonForVisit'] = reasonForVisit.trim();
    }
    if (chatbotSummary != null && chatbotSummary.trim().isNotEmpty) {
      body['chatbotSummary'] = chatbotSummary.trim();
    }

    final response = await api.post(EndPoints.appointments, data: body);
    final data = _extractData(response);
    if (data == null) {
      throw StateError('Empty create appointment response');
    }
    return Appointment.fromJson(data);
  }

  /// PATCH appointments/:id/reschedule
  Future<Appointment> reschedule({
    required String appointmentId,
    required String scheduledAt,
  }) async {
    final response = await api.patch(
      EndPoints.appointmentReschedule(appointmentId),
      data: {'scheduledAt': scheduledAt},
    );
    final data = _extractData(response);
    if (data == null) {
      throw StateError('Empty reschedule response');
    }
    return Appointment.fromJson(data);
  }

  /// POST appointments/:id/cancel
  Future<Appointment> cancel({
    required String appointmentId,
    String? cancellationReason,
  }) async {
    final body = <String, dynamic>{};
    if (cancellationReason != null && cancellationReason.trim().isNotEmpty) {
      body['cancellationReason'] = cancellationReason.trim();
    }
    final response = await api.post(
      EndPoints.appointmentCancel(appointmentId),
      data: body.isEmpty ? null : body,
    );
    final data = _extractData(response);
    if (data == null) {
      throw StateError('Empty cancel response');
    }
    return Appointment.fromJson(data);
  }

  /// POST appointments/check-in
  Future<Appointment> checkIn({
    required String patientId,
    required String clinicCheckInCode,
    required double latitude,
    required double longitude,
    String? appointmentId,
  }) async {
    final body = <String, dynamic>{
      'patientId': int.parse(patientId),
      'clinicCheckInCode': clinicCheckInCode,
      'latitude': latitude,
      'longitude': longitude,
    };
    if (appointmentId != null && appointmentId.isNotEmpty) {
      body['appointmentId'] = int.parse(appointmentId);
    }
    final response = await api.post(EndPoints.appointmentsCheckIn, data: body);
    final data = _extractData(response);
    if (data == null) {
      throw StateError('Empty check-in response');
    }
    return Appointment.fromJson(data);
  }

  Map<String, dynamic>? _extractData(dynamic response) {
    if (response is! Map) return null;
    final data = Map<String, dynamic>.from(response)['data'];
    if (data == null) return null;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }
}
