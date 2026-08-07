import 'package:dental_app/core/utils/patient_profile_image.dart';

/// Display helpers for medical-archive items (XRAY / REPORT).
class MedicalArchiveHelper {
  MedicalArchiveHelper._();

  static const typeXray = 'XRAY';
  static const typeReport = 'REPORT';

  static String titleOf(Map<String, dynamic> item) =>
      (item['title'] ?? '').toString().trim();

  static String? mediaPublicUrl(Map<String, dynamic> item) {
    final media = item['mediaFile'];
    if (media is! Map) return null;
    final raw = media['publicUrl']?.toString();
    return PatientProfileImage.resolve(raw);
  }

  static String? mimeTypeOf(Map<String, dynamic> item) {
    final media = item['mediaFile'];
    if (media is! Map) return null;
    return media['mimeType']?.toString();
  }

  /// "Plan name · Session title" (skips missing parts).
  static String planSessionLabel(Map<String, dynamic> item) {
    final session = item['session'];
    if (session is! Map) return '';

    final sessionTitle = (session['title'] ?? '').toString().trim();
    final plan = session['plan'];
    String planName = '';
    if (plan is Map) {
      planName = (plan['name'] ?? '').toString().trim();
    }

    if (planName.isNotEmpty && sessionTitle.isNotEmpty) {
      return '$planName · $sessionTitle';
    }
    if (planName.isNotEmpty) return planName;
    return sessionTitle;
  }

  static String formatDate(String? iso) {
    if (iso == null || iso.trim().isEmpty) return '-';
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '-';
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String formatDateOf(Map<String, dynamic> item) =>
      formatDate(item['createdAt']?.toString());
}
