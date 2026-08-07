/// Helpers for completed-session rating window + display.
class SessionRatingHelper {
  SessionRatingHelper._();

  /// True when the user can still rate this session now.
  static bool canRate(Map<String, dynamic>? session) {
    if (session == null) return false;
    final pending = session['pendingRating'];
    if (pending is! Map) return false;
    if (pending['enabled'] != true) return false;
    final untilRaw = pending['canRateUntil']?.toString();
    if (untilRaw == null || untilRaw.isEmpty) return false;
    final until = DateTime.tryParse(untilRaw);
    if (until == null) return false;
    return DateTime.now().toUtc().isBefore(until.toUtc());
  }

  static int? ratingOf(Map<String, dynamic>? session) {
    final r = session?['rating'];
    if (r is int) return r;
    if (r is num) return r.toInt();
    return int.tryParse(r?.toString() ?? '');
  }

  static DateTime? _parseLocal(String? iso) {
    if (iso == null || iso.trim().isEmpty) return null;
    return DateTime.tryParse(iso)?.toLocal();
  }

  /// Date only: yyyy-MM-dd
  static String formatCompletedDate(String? iso) {
    final dt = _parseLocal(iso);
    if (dt == null) return '-';
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Time only: HH:mm
  static String formatCompletedTime(String? iso) {
    final dt = _parseLocal(iso);
    if (dt == null) return '-';
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  /// Home pendingRating still within window.
  static bool homePendingCanRate(Map<String, dynamic>? pendingRating) {
    if (pendingRating == null) return false;
    final untilRaw = pendingRating['canRateUntil']?.toString();
    if (untilRaw == null || untilRaw.isEmpty) return false;
    final until = DateTime.tryParse(untilRaw);
    if (until == null) return false;
    return DateTime.now().toUtc().isBefore(until.toUtc());
  }
}
