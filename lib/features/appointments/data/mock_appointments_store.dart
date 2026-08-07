import 'package:flutter/foundation.dart';

import 'mock_appointments_data.dart';
import 'models/appointment_model.dart';

/// مخزن مؤقت لمواعيد الجلسة الحالية (mock) - لحد ما يتوفر الـ backend.
/// بيستخدمه تبويب "مواعيدي" ومسار تأكيد الحجز حتى الموعد الجديد
/// يبين فوراً بعد التأكيد بدون ما نحتاج API.
class MockAppointmentsStore extends ChangeNotifier {
  MockAppointmentsStore._() : _appointments = buildMockAppointments();

  static final MockAppointmentsStore instance = MockAppointmentsStore._();

  List<Appointment> _appointments;

  List<Appointment> get appointments => List.unmodifiable(_appointments);

  void add(Appointment appointment) {
    _appointments = [appointment, ..._appointments];
    notifyListeners();
  }

  void replace(Appointment updated) {
    _appointments = _appointments
        .map((a) => a.id == updated.id ? updated : a)
        .toList();
    notifyListeners();
  }
}
