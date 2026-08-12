import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// كل الحالات يلي ممكن يمر فيها الموعد خلال دورة حياته:
/// PENDING_CONFIRMATION → CONFIRMED → CHECKED_IN → IN_TREATMENT → COMPLETED
/// وبأي لحظة قبل ما يوصل العيادة ممكن يتفرع لـ CANCELLED، أو لـ NO_SHOW
/// إذا ما حضر المريض بعد ما تأكد الموعد.
enum AppointmentStatus {
  pendingConfirmation,
  confirmed,
  checkedIn,
  inTreatment,
  completed,
  cancelled,
  noShow;

  /// تحويل من قيمة الـ API (PENDING_CONFIRMATION، CONFIRMED، …).
  static AppointmentStatus fromApiValue(String raw) {
    switch (raw.toUpperCase()) {
      case 'PENDING_CONFIRMATION':
        return AppointmentStatus.pendingConfirmation;
      case 'CONFIRMED':
        return AppointmentStatus.confirmed;
      case 'CHECKED_IN':
        return AppointmentStatus.checkedIn;
      case 'IN_TREATMENT':
        return AppointmentStatus.inTreatment;
      case 'COMPLETED':
        return AppointmentStatus.completed;
      case 'CANCELLED':
        return AppointmentStatus.cancelled;
      case 'NO_SHOW':
        return AppointmentStatus.noShow;
      default:
        return AppointmentStatus.pendingConfirmation;
    }
  }
}

extension AppointmentStatusX on AppointmentStatus {
  /// مفتاح الترجمة المستخدم بـ .tr() لعرض اسم الحالة.
  String get labelKey {
    switch (this) {
      case AppointmentStatus.pendingConfirmation:
        return 'Pending Confirmation';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.checkedIn:
        return 'Checked In';
      case AppointmentStatus.inTreatment:
        return 'In Treatment';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No Show';
    }
  }

  /// لون شارة الحالة - كل حالة بلونها المميز حتى تبين الفروقات بلمحة.
  Color get color {
    switch (this) {
      case AppointmentStatus.pendingConfirmation:
        return AppColors.accent;
      case AppointmentStatus.confirmed:
        return AppColors.primary;
      case AppointmentStatus.checkedIn:
        return AppColors.secondary;
      case AppointmentStatus.inTreatment:
        return AppColors.tertiary;
      case AppointmentStatus.completed:
        return AppColors.success;
      case AppointmentStatus.cancelled:
        return AppColors.error;
      case AppointmentStatus.noShow:
        return AppColors.textSecondary;
    }
  }

  /// هل هالحالة ضمن تبويب "القادمة"؟ (الباقي بيروح لتبويب "السابقة").
  bool get isUpcoming =>
      this == AppointmentStatus.pendingConfirmation ||
      this == AppointmentStatus.confirmed ||
      this == AppointmentStatus.checkedIn ||
      this == AppointmentStatus.inTreatment;

  /// أزرار الإلغاء/التعديل بتظهر بس بهالحالتين (قبل ما يوصل المريض العيادة فعلياً).
  bool get allowsCancelOrReschedule =>
      this == AppointmentStatus.pendingConfirmation ||
      this == AppointmentStatus.confirmed;
}
