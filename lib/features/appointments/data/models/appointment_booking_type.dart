/// نوع الموعد اللي بيستقبله الـ availability API.
enum AppointmentBookingType {
  consultation,
  followUp;

  String get apiValue {
    switch (this) {
      case AppointmentBookingType.consultation:
        return 'CONSULTATION';
      case AppointmentBookingType.followUp:
        return 'FOLLOW_UP';
    }
  }

  static AppointmentBookingType? fromApiValue(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'CONSULTATION':
        return AppointmentBookingType.consultation;
      case 'FOLLOW_UP':
        return AppointmentBookingType.followUp;
      default:
        return null;
    }
  }
}
