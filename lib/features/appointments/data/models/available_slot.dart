/// وقت بدء مقترح من استجابة GET appointments/availability/slots (HH:mm).
class AvailableSlot {
  final String startTime;

  const AvailableSlot({required this.startTime});

  factory AvailableSlot.fromJson(Map<String, dynamic> json) {
    return AvailableSlot(
      startTime: (json['startTime'] ?? '').toString(),
    );
  }
}
