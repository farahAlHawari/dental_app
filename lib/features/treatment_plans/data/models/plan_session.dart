import 'package:dental_app/features/treatment_plans/data/models/session_encounter.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_session_status.dart';

class PlanSession {
  final String id;
  final String title;
  final int sessionOrder;
  final TreatmentSessionStatus status;
  final bool canBook;
  final int? durationMinutes;
  final String? estimatedCost;
  final DateTime? availableForBookingAt;
  final DateTime? completedAt;
  final int? rating;
  final bool pendingRatingEnabled;
  final SessionEncounter? encounter;

  const PlanSession({
    required this.id,
    required this.title,
    required this.sessionOrder,
    required this.status,
    required this.canBook,
    this.durationMinutes,
    this.estimatedCost,
    this.availableForBookingAt,
    this.completedAt,
    this.rating,
    this.pendingRatingEnabled = false,
    this.encounter,
  });

  factory PlanSession.fromJson(Map<String, dynamic> json) {
    final pending = json['pendingRating'];
    final pendingEnabled = pending is Map && pending['enabled'] == true;
    final untilRaw = pending is Map ? pending['canRateUntil']?.toString() : null;
    final until = DateTime.tryParse(untilRaw ?? '');
    final canRateNow = pendingEnabled &&
        (until == null || !DateTime.now().toUtc().isAfter(until.toUtc()));

    final ratingRaw = json['rating'];
    final completedRaw = json['completedAt']?.toString();
    final duration = json['durationMinutes'];

    return PlanSession(
      id: '${json['id']}',
      title: json['title']?.toString().trim() ?? '',
      sessionOrder: json['sessionOrder'] is int
          ? json['sessionOrder'] as int
          : int.tryParse('${json['sessionOrder']}') ?? 0,
      status: TreatmentSessionStatus.fromApiValue(json['status']?.toString()),
      canBook: json['canBook'] == true,
      durationMinutes: duration is int ? duration : int.tryParse('$duration'),
      estimatedCost: json['estimatedCost']?.toString(),
      availableForBookingAt:
          DateTime.tryParse(json['availableForBookingAt']?.toString() ?? '')
              ?.toLocal(),
      completedAt: DateTime.tryParse(completedRaw ?? '')?.toLocal(),
      rating: ratingRaw is int
          ? ratingRaw
          : int.tryParse(ratingRaw?.toString() ?? ''),
      pendingRatingEnabled: canRateNow,
      encounter: _parseEncounter(json['encounter']),
    );
  }

  static SessionEncounter? _parseEncounter(dynamic raw) {
    if (raw is Map<String, dynamic>) return SessionEncounter.fromJson(raw);
    if (raw is Map) {
      return SessionEncounter.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  bool get isBookablePending =>
      status == TreatmentSessionStatus.pending && canBook;

  bool get isLockedPending =>
      status == TreatmentSessionStatus.pending && !canBook;

  bool get isActiveVisit =>
      status == TreatmentSessionStatus.booked ||
      status == TreatmentSessionStatus.inTreatment;

  bool get showEstimatedCost =>
      (status == TreatmentSessionStatus.pending ||
          status == TreatmentSessionStatus.booked) &&
      estimatedCost != null &&
      estimatedCost!.trim().isNotEmpty;

  String get badgeLabelKey {
    switch (status) {
      case TreatmentSessionStatus.pending:
        return canBook ? 'Available for booking' : 'Waiting';
      case TreatmentSessionStatus.booked:
        return 'Booked';
      case TreatmentSessionStatus.inTreatment:
        return 'In Treatment';
      case TreatmentSessionStatus.completed:
        return 'Completed';
      case TreatmentSessionStatus.cancelled:
        return 'Cancelled';
    }
  }
}
