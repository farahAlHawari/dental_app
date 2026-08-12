/// يوم من استجابة GET appointments/availability/days.
class AvailableDay {
  final DateTime date;
  final bool isWorkingDay;
  final bool hasAvailableSlots;

  const AvailableDay({
    required this.date,
    required this.isWorkingDay,
    required this.hasAvailableSlots,
  });

  bool get isBookable => isWorkingDay && hasAvailableSlots;

  factory AvailableDay.fromJson(Map<String, dynamic> json) {
    final rawDate = (json['date'] ?? '').toString();
    final parsed = DateTime.tryParse(rawDate);
    return AvailableDay(
      date: parsed != null
          ? DateTime(parsed.year, parsed.month, parsed.day)
          : DateTime.now(),
      isWorkingDay: json['isWorkingDay'] == true,
      hasAvailableSlots: json['hasAvailableSlots'] == true,
    );
  }
}
