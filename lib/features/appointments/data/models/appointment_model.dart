import 'appointment_status.dart';

/// نموذج الموعد - الحقول هون مبنية بشكل يسهّل تحويلها لاحقاً من/إلى استجابة
/// الـ API الحقيقية (نفس الأسماء المتوقعة تقريباً: scheduledAt, status...).
///
/// TODO: لما يوصل الـ backend، رح تصير فعالية زر الإلغاء/التعديل مبنية على
/// flags جاهزة بالاستجابة (مثلاً canCancel / canReschedule) بدل ما تعتمد بس
/// على الحالة - لأنها بتاخد بعين الاعتبار مهلة الإلغاء القابلة للتخصيص لكل
/// عيادة. حالياً منعتمد فقط على AppointmentStatus.allowsCancelOrReschedule.
class Appointment {
  final String id;
  final String visitTypeLabel;
  final String? doctorName;
  final String? doctorSpecialty;
  final String? doctorImagePath;
  final DateTime scheduledAt;
  final AppointmentStatus status;

  /// لو الموعد مرتبط بجلسة علاجية ضمن خطة قائمة - لما ينلغى الموعد، الجلسة
  /// نفسها بتضل موجودة وجاهزة لحجز موعد جديد إلها (ما بتتلغى مع الموعد).
  final String? treatmentSessionId;

  const Appointment({
    required this.id,
    required this.visitTypeLabel,
    this.doctorName,
    this.doctorSpecialty,
    this.doctorImagePath,
    required this.scheduledAt,
    required this.status,
    this.treatmentSessionId,
  });

  Appointment copyWith({
    String? id,
    String? visitTypeLabel,
    String? doctorName,
    String? doctorSpecialty,
    String? doctorImagePath,
    DateTime? scheduledAt,
    AppointmentStatus? status,
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
      treatmentSessionId: treatmentSessionId ?? this.treatmentSessionId,
    );
  }
}
