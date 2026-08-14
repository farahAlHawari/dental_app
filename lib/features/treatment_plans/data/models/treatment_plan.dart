import 'package:dental_app/features/treatment_plans/data/models/plan_session.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan_status.dart';

class TreatmentPlan {
  final String id;
  final String name;
  final TreatmentPlanStatus status;
  final int sessionCount;
  final int progressPercent;
  final String? estimatedCost;
  final String? actualCost;
  final DateTime? createdAt;
  final List<PlanSession>? _sessions;

  const TreatmentPlan({
    required this.id,
    required this.name,
    required this.status,
    required this.sessionCount,
    required this.progressPercent,
    this.estimatedCost,
    this.actualCost,
    this.createdAt,
    List<PlanSession>? sessions,
  }) : _sessions = sessions;

  /// List endpoint has no nested sessions; missing/null becomes [].
  List<PlanSession> get sessions => _sessions ?? const [];

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) {
    final createdRaw = json['createdAt']?.toString();
    final parsedSessions = _parseSessions(json['sessions']);
    parsedSessions.sort((a, b) => a.sessionOrder.compareTo(b.sessionOrder));

    return TreatmentPlan(
      id: '${json['id']}',
      name: (json['name']?.toString().trim().isNotEmpty ?? false)
          ? json['name'].toString().trim()
          : '',
      status: TreatmentPlanStatus.fromApiValue(json['status']?.toString()),
      sessionCount: json['sessionCount'] is int
          ? json['sessionCount'] as int
          : int.tryParse('${json['sessionCount']}') ?? parsedSessions.length,
      progressPercent: json['progressPercent'] is int
          ? json['progressPercent'] as int
          : int.tryParse('${json['progressPercent']}') ?? 0,
      estimatedCost: json['estimatedCost']?.toString(),
      actualCost: json['actualCost']?.toString(),
      createdAt: DateTime.tryParse(createdRaw ?? '')?.toLocal(),
      sessions: parsedSessions,
    );
  }

  static List<PlanSession> _parseSessions(dynamic raw) {
    if (raw is! List) return <PlanSession>[];
    final items = <PlanSession>[];
    for (final item in raw) {
      if (item is Map<String, dynamic>) {
        items.add(PlanSession.fromJson(item));
      } else if (item is Map) {
        items.add(PlanSession.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return items;
  }

  double get progress => (progressPercent.clamp(0, 100)) / 100.0;

  /// Completed plans show billed actual cost only when the API sends it.
  bool get usesActualCost {
    if (status != TreatmentPlanStatus.completed) return false;
    final actual = actualCost?.trim();
    return actual != null && actual.isNotEmpty;
  }

  String? get displayCost {
    if (usesActualCost) {
      final actual = actualCost?.trim();
      if (actual != null && actual.isNotEmpty) return actual;
    }
    final estimated = estimatedCost?.trim();
    if (estimated != null && estimated.isNotEmpty) return estimated;
    return null;
  }

  String get displayCostLabelKey =>
      usesActualCost ? 'Actual cost' : 'Estimated cost';

  int get completedSessionCount {
    if (sessionCount <= 0) return 0;
    return ((progressPercent.clamp(0, 100) / 100) * sessionCount).round();
  }

  /// Current session number for the home-style badge (1-based).
  int get currentSession {
    if (sessions.isNotEmpty) {
      final bookable = sessions.where((s) => s.isBookablePending);
      if (bookable.isNotEmpty) return bookable.first.sessionOrder;
      final active = sessions.where((s) => s.isActiveVisit);
      if (active.isNotEmpty) return active.first.sessionOrder;
      if (status == TreatmentPlanStatus.completed) {
        return sessionCount > 0 ? sessionCount : sessions.length;
      }
    }
    if (sessionCount <= 0) return 0;
    if (status == TreatmentPlanStatus.completed) return sessionCount;
    final completed = completedSessionCount;
    if (completed >= sessionCount) return sessionCount;
    return completed + 1;
  }

  int? get highlightedSessionIndex {
    final bookable = sessions.indexWhere((s) => s.isBookablePending);
    if (bookable >= 0) return bookable;
    final active = sessions.indexWhere((s) => s.isActiveVisit);
    if (active >= 0) return active;
    return null;
  }

  int get reportCount => _attachmentCount('REPORT');

  int get radiographCount => _attachmentCount('XRAY');

  int get prescriptionCount {
    var count = 0;
    for (final session in sessions) {
      final text = session.encounter?.prescription;
      if (text != null && text.trim().isNotEmpty) count++;
    }
    return count;
  }

  int get beforeAfterCount {
    var count = 0;
    for (final session in sessions) {
      final photos = session.encounter?.attachments
              .where((a) => a.type == 'PHOTO')
              .length ??
          0;
      if (photos >= 2) count++;
    }
    return count;
  }

  /// Newest plan by [createdAt]. Plans without a date lose to dated ones.
  static TreatmentPlan? newestByCreatedAt(Iterable<TreatmentPlan> plans) {
    TreatmentPlan? newest;
    for (final plan in plans) {
      if (newest == null) {
        newest = plan;
        continue;
      }
      final current = plan.createdAt;
      final best = newest.createdAt;
      if (current == null) continue;
      if (best == null || current.isAfter(best)) {
        newest = plan;
      }
    }
    return newest;
  }

  int _attachmentCount(String type) {
    var count = 0;
    for (final session in sessions) {
      count += session.encounter?.attachments
              .where((a) => a.type == type)
              .length ??
          0;
    }
    return count;
  }
}
