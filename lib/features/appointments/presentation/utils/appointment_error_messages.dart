import 'package:easy_localization/easy_localization.dart';

/// يعرّف رسالة الخطأ من Failure: أكواد الباك + HTTP + شبكة.
String resolveAppointmentFailure({
  required String? code,
  required String fallback,
  int? statusCode,
}) {
  if (statusCode == 0) {
    return 'No Internet Connection'.tr();
  }
  if (statusCode == 403) {
    return 'You do not have access to this appointment.'.tr();
  }
  if (statusCode == 404) {
    return 'Appointment not found.'.tr();
  }
  return mapAppointmentError(code, fallback);
}

/// ترجمة أكواد أخطاء المواعيد (availability + create + cancel + check-in).
String mapAppointmentError(String? code, String fallback) {
  switch (code) {
    case 'ONLINE_BOOKING_DISABLED':
      return 'Online booking is currently disabled.'.tr();
    case 'PATIENT_ARCHIVED_CANNOT_BOOK':
      return 'This patient account is archived and cannot book.'.tr();
    case 'TREATMENT_SESSION_REQUIRED':
      return 'A treatment session is required for follow-up booking.'.tr();
    case 'APPOINTMENT_SESSION_NOT_BOOKABLE':
      return 'This treatment session cannot be booked right now.'.tr();
    case 'APPOINTMENT_TYPE_SESSION_MISMATCH':
      return 'This appointment type does not match the selected session.'.tr();
    case 'ACTIVE_CONSULTATION_EXISTS':
      return 'There is a previous incomplete consultation appointment for this patient.'
          .tr();
    case 'APPOINTMENT_SLOT_UNAVAILABLE':
      return 'This time slot is no longer available.'.tr();
    case 'APPOINTMENT_OUTSIDE_HORIZON':
    case 'APPOINTMENT_PAST_NOT_ALLOWED':
      return 'The selected date is not allowed for booking.'.tr();
    case 'APPOINTMENT_OUTSIDE_CANCEL_RESCHEDULE_WINDOW':
      return 'The deadline to modify or cancel this appointment has passed.'.tr();
    case 'APPOINTMENT_NOT_RESCHEDULABLE':
      return 'This appointment cannot be rescheduled.'.tr();
    case 'APPOINTMENT_NOT_CANCELLABLE':
      return 'This appointment cannot be cancelled.'.tr();
    case 'APPOINTMENT_NOT_CHECKABLE':
      return 'This appointment cannot be checked in right now.'.tr();
    case 'APPOINTMENT_CHECKIN_CODE_INVALID':
      return 'Invalid check-in code. Please scan the clinic QR again.'.tr();
    case 'APPOINTMENT_CHECKIN_OUTSIDE_GEOFENCE':
      return 'You must be at the clinic location to check in.'.tr();
    case 'APPOINTMENT_CHECKIN_NONE_TODAY':
      return 'No confirmed appointment found for check-in today.'.tr();
    case 'APPOINTMENT_CHECKIN_AMBIGUOUS':
      return 'Multiple appointments today. Please open the appointment and try again.'
          .tr();
    case 'CLINIC_LOCATION_NOT_CONFIGURED':
      return 'Clinic location is not configured. Please contact reception.'.tr();
    default:
      if (code != null && code.startsWith('APPOINTMENT_CHECKIN_')) {
        return 'Check-in failed. Please try again at the clinic.'.tr();
      }
      return fallback;
  }
}
