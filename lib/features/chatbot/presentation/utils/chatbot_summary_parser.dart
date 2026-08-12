import 'dart:convert';

/// يستخرج نص التلخيص من رد Gemini — أحياناً يرجع JSON بنفس شكل TRIAGE.
String normalizeChatbotSummary(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return trimmed;
  if (!trimmed.startsWith('{')) return trimmed;

  try {
    final cleaned = trimmed
        .replaceFirst(RegExp(r'^```json\s*', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^```\s*'), '')
        .replaceFirst(RegExp(r'\s*```$'), '')
        .trim();

    final data = jsonDecode(cleaned);
    if (data is! Map) return trimmed;

    final map = Map<String, dynamic>.from(data);
    final summary = map['summary'];
    if (summary is String && summary.trim().isNotEmpty) {
      return summary.trim();
    }

    final reply = map['reply'];
    if (reply is String && reply.trim().isNotEmpty) {
      return reply.trim();
    }
  } catch (_) {
    // ليس JSON صالح — نرجّع النص كما هو
  }

  return trimmed;
}
