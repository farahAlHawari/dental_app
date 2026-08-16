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
  final String? sessionTitleAr;
  final String? sessionTitleEn;
  /// اسم الجلسة المترجم من الـ list API (`treatmentSessionName`).
  final String? treatmentSessionName;
  /// اسم الخطة المترجم من الـ list API (`treatmentPlanName`).
  final String? treatmentPlanName;
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
    this.sessionTitleAr,
    this.sessionTitleEn,
    this.treatmentSessionName,
    this.treatmentPlanName,
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
      visitTypeLabel: _visitLabel(bookingType),
      scheduledAt: scheduledRaw != null
          ? DateTime.parse(scheduledRaw).toLocal()
          : DateTime.now(),
      status: AppointmentStatus.fromApiValue(
        json['status']?.toString() ?? 'PENDING_CONFIRMATION',
      ),
      bookingType: bookingType,
      reasonForVisit: reason,
      sessionTitleAr: _nestedSessionTitle(json, 'titleAr'),
      sessionTitleEn: _nestedSessionTitle(json, 'titleEn'),
      treatmentSessionName: _trimOrNull(json['treatmentSessionName']),
      treatmentPlanName: _trimOrNull(json['treatmentPlanName']),
      durationMinutes: json['durationMinutes'] is int
          ? json['durationMinutes'] as int
          : int.tryParse('${json['durationMinutes']}'),
      isWaiting: json['isWaiting'] == true,
      treatmentSessionId: json['treatmentSessionId']?.toString(),
    );
  }

  static String _visitLabel(AppointmentBookingType? type) {
    if (type == AppointmentBookingType.followUp) {
      return 'Follow-up appointment in my treatment plan'.tr();
    }
    return 'Initial Consultation / First Visit'.tr();
  }

  static String? _trimOrNull(dynamic value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }

  static String? _nestedSessionTitle(Map<String, dynamic> json, String key) {
    final nested = json['treatmentSession'];
    if (nested is Map && nested[key] != null) {
      final value = nested[key].toString().trim();
      if (value.isNotEmpty) return value;
    }
    if (key == 'titleAr' || key == 'titleEn') {
      final fallback = json['sessionTitle']?.toString().trim();
      if (fallback != null && fallback.isNotEmpty) return fallback;
    }
    return null;
  }

  String? localizedSessionTitle(String languageCode) {
    final flat = treatmentSessionName?.trim();
    if (flat != null && flat.isNotEmpty) return flat;

    final ar = sessionTitleAr?.trim();
    final en = sessionTitleEn?.trim();
    if (languageCode == 'ar') {
      if (ar != null && ar.isNotEmpty) return ar;
      if (en != null && en.isNotEmpty) return en;
      return null;
    }
    if (en != null && en.isNotEmpty) return en;
    if (ar != null && ar.isNotEmpty) return ar;
    return null;
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
    String? sessionTitleAr,
    String? sessionTitleEn,
    String? treatmentSessionName,
    String? treatmentPlanName,
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
      sessionTitleAr: sessionTitleAr ?? this.sessionTitleAr,
      sessionTitleEn: sessionTitleEn ?? this.sessionTitleEn,
      treatmentSessionName:
          treatmentSessionName ?? this.treatmentSessionName,
      treatmentPlanName: treatmentPlanName ?? this.treatmentPlanName,
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
