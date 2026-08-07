/// Shared date helpers for patient APIs.
///
/// IMPORTANT: never use `date.toIso8601String().split('T').first` for birth dates.
/// On UTC+ timezones that can shift the calendar day (e.g. May 12 -> May 11).
class ApiDateUtils {
  /// Builds yyyy-MM-dd from a DatePicker [DateTime] using local calendar fields.
  static String fromPicker(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Formats a date for the backend as date-only: YYYY-MM-DD (no time).
  /// Accepts ISO strings from the API and normalizes them.
  static String toApiDate(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return trimmed;

    final dateOnly = _extractDateOnly(trimmed);
    if (dateOnly != null) return dateOnly;

    final parsed = DateTime.tryParse(trimmed);
    if (parsed == null) return trimmed;

    return fromPicker(DateTime(parsed.year, parsed.month, parsed.day));
  }

  /// Formats a backend date for UI / date pickers as yyyy-MM-dd.
  static String toDisplayDate(dynamic input) {
    if (input == null) return '';
    final text = input.toString().trim();
    if (text.isEmpty) return '';

    final dateOnly = _extractDateOnly(text);
    if (dateOnly != null) return dateOnly;

    final parsed = DateTime.tryParse(text);
    if (parsed == null) return text;

    return fromPicker(DateTime(parsed.year, parsed.month, parsed.day));
  }

  static String? _extractDateOnly(String text) {
    final match = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(text);
    if (match == null) return null;
    return '${match.group(1)}-${match.group(2)}-${match.group(3)}';
  }

  /// Maps API gender back to UI GenderSelector values.
  static String toUiGender(dynamic gender) {
    final text = (gender ?? '').toString().trim();
    switch (text.toUpperCase()) {
      case 'MALE':
      case 'M':
        return 'Male';
      case 'FEMALE':
      case 'F':
        return 'Female';
      default:
        if (text.toLowerCase() == 'male') return 'Male';
        if (text.toLowerCase() == 'female') return 'Female';
        return text;
    }
  }

  /// Maps UI gender ("Male"/"Female") to API enum values.
  static String toApiGender(String gender) {
    switch (gender.trim().toUpperCase()) {
      case 'MALE':
      case 'M':
        return 'MALE';
      case 'FEMALE':
      case 'F':
        return 'FEMALE';
      default:
        final lower = gender.trim().toLowerCase();
        if (lower == 'male') return 'MALE';
        if (lower == 'female') return 'FEMALE';
        return gender.trim().toUpperCase();
    }
  }
}
