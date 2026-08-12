import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/data/models/appointment_status.dart';
import 'package:easy_localization/easy_localization.dart';

/// نموذج الموعد — متوافق مع استجابات list / upcoming / detail / create.
class Appointment {
  final String id;
  final String visitTypeLabel;
  final String? doctorName;
  final String? doctorSpecialty;
  final String? doctorImagePath;
  final DateTime scheduledAt;
  final AppointmentStatus status;
  final AppointmentBookingType? bookingType;
  final String? reasonForVisit;
  final int? durationMinutes;
  final bool isWaiting;

  /// لو الموعد مرتبط بجلسة علاجية — مطلوب لإعادة الجدولة والمتابعة.
  final String? treatmentSessionId;

  const Appointment({
    required this.id,
    required this.visitTypeLabel,
    this.doctorName,
    this.doctorSpecialty,
    this.doctorImagePath,
    required this.scheduledAt,
    required this.status,
    this.bookingType,
    this.reasonForVisit,
    this.durationMinutes,
    this.isWaiting = false,
    this.treatmentSessionId,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final typeRaw = json['type']?.toString();
    final bookingType = AppointmentBookingType.fromApiValue(typeRaw);
    final reason = json['reasonForVisit']?.toString();
    final scheduledRaw = json['scheduledAt']?.toString();
    return Appointment(
      id: '${json['id']}',
      visitTypeLabel: _visitLabel(bookingType, reason),
      scheduledAt: scheduledRaw != null
          ? DateTime.parse(scheduledRaw).toLocal()
          : DateTime.now(),
      status: AppointmentStatus.fromApiValue(
        json['status']?.toString() ?? 'PENDING_CONFIRMATION',
      ),
      bookingType: bookingType,
      reasonForVisit: reason,
      durationMinutes: json['durationMinutes'] is int
          ? json['durationMinutes'] as int
          : int.tryParse('${json['durationMinutes']}'),
      isWaiting: json['isWaiting'] == true,
      treatmentSessionId: json['treatmentSessionId']?.toString(),
    );
  }

  static String _visitLabel(
    AppointmentBookingType? type,
    String? reason,
  ) {
    if (reason != null && reason.trim().isNotEmpty) return reason.trim();
    if (type == AppointmentBookingType.followUp) {
      return 'Follow-up Session'.tr();
    }
    return 'Consultation'.tr();
  }

  Appointment copyWith({
    String? id,
    String? visitTypeLabel,
    String? doctorName,
    String? doctorSpecialty,
    String? doctorImagePath,
    DateTime? scheduledAt,
    AppointmentStatus? status,
    AppointmentBookingType? bookingType,
    String? reasonForVisit,
    int? durationMinutes,
    bool? isWaiting,
    String? treatmentSessionId,
  }) {
    return Appointment(
      id: id ?? this.id,
      visitTypeLabel: visitTypeLabel ?? this.visitTypeLabel,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      doctorImagePath: doctorImagePath ?? this.doctorImagePath,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      bookingType: bookingType ?? this.bookingType,
      reasonForVisit: reasonForVisit ?? this.reasonForVisit,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isWaiting: isWaiting ?? this.isWaiting,
      treatmentSessionId: treatmentSessionId ?? this.treatmentSessionId,
    );
  }
}

class AppointmentListResult {
  final List<Appointment> items;
  final int total;

  const AppointmentListResult({required this.items, required this.total});
}
