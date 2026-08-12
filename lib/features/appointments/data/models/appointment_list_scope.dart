/// فلتر قائمة المواعيد — UPCOMING أو PAST.
enum AppointmentListScope {
  upcoming,
  past;

  String get apiValue {
    switch (this) {
      case AppointmentListScope.upcoming:
        return 'UPCOMING';
      case AppointmentListScope.past:
        return 'PAST';
    }
  }
}
