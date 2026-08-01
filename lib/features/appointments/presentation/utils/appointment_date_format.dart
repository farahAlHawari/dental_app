import 'package:easy_localization/easy_localization.dart';

/// نفس مفاتيح أسماء الأيام/الأشهر المستخدمة بباقي شاشات الحجز
/// (`select_date_time_page.dart`, `booking_confirmation_page.dart`) - مجمّعة
/// هون بمكان واحد لاستخدامها بكرت الموعد بدون تكرارها من جديد.
const List<String> weekdayFullKeys = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const List<String> monthKeys = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String formatAppointmentDate(DateTime date) {
  final weekday = weekdayFullKeys[date.weekday - 1].tr();
  final month = monthKeys[date.month - 1].tr();
  return '$weekday ${date.day} $month ${date.year}';
}

String formatAppointmentTime(DateTime date) {
  final hour24 = date.hour;
  final minute = date.minute.toString().padLeft(2, '0');
  final isAm = hour24 < 12;
  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
  final period = (isAm ? 'AM' : 'PM').tr();
  return '$hour12:$minute $period';
}
