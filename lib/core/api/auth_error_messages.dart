/// Backend auth 401 messages — no `code` field; match status + message + path.
class AuthErrorMessages {
  AuthErrorMessages._();

  static const String credentialsAr = 'رقم الهاتف أو كلمة المرور غير صحيحة';
  static const String credentialsEn = 'Invalid phone number or password';

  static const String sessionAr = 'جلسة الدخول غير صالحة أو منتهية';
  static const String sessionEn = 'Your session is invalid or has expired';

  /// Arabic: exact (after trim). English: case-insensitive.
  /// Also accepts ErrorModel form: `"message (details)"`.
  static bool isInvalidCredentials(String? message) {
    final m = (message ?? '').trim();
    if (m.isEmpty) return false;
    if (m == credentialsAr || m.startsWith('$credentialsAr (')) return true;
    final lower = m.toLowerCase();
    final en = credentialsEn.toLowerCase();
    return lower == en || lower.startsWith('$en (');
  }

  static bool isInvalidSession(String? message) {
    final m = (message ?? '').trim();
    if (m.isEmpty) return false;
    if (m == sessionAr || m.startsWith('$sessionAr (')) return true;
    final lower = m.toLowerCase();
    final en = sessionEn.toLowerCase();
    return lower == en || lower.startsWith('$en (');
  }

  /// Pulls `message` from typical API error body maps.
  static String? messageFromResponseData(dynamic data) {
    if (data is! Map) return null;
    final raw = data['message'];
    if (raw is List) {
      return raw.map((e) => e.toString()).join(', ').trim();
    }
    if (raw == null) return null;
    return raw.toString().trim();
  }
}
