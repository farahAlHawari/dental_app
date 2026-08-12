/// جلسة علاجية — GET treatment-sessions/for-booking
class BookableSession {
  final String id;
  final String title;
  final String planName;
  final String treatmentPlanId;
  final int sessionOrder;
  final bool canBook;
  final int? durationMinutes;
  final String? estimatedCost;
  final DateTime? availableForBookingAt;

  const BookableSession({
    required this.id,
    required this.title,
    required this.planName,
    required this.treatmentPlanId,
    required this.sessionOrder,
    required this.canBook,
    this.durationMinutes,
    this.estimatedCost,
    this.availableForBookingAt,
  });

  factory BookableSession.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? '').toString();
    final planName = (json['planName'] ?? '').toString();

    DateTime? availableAt;
    final rawDate = json['availableForBookingAt'];
    if (rawDate != null) {
      availableAt = DateTime.tryParse(rawDate.toString());
    }

    final cost = json['estimatedCost'];
    final duration = json['durationMinutes'];

    return BookableSession(
      id: '${json['id']}',
      title: title,
      planName: planName,
      treatmentPlanId: '${json['treatmentPlanId'] ?? ''}',
      sessionOrder: json['sessionOrder'] is int
          ? json['sessionOrder'] as int
          : int.tryParse('${json['sessionOrder']}') ?? 0,
      canBook: json['canBook'] == true,
      durationMinutes: duration is int
          ? duration
          : int.tryParse('$duration'),
      estimatedCost: cost?.toString(),
      availableForBookingAt: availableAt,
    );
  }
}
