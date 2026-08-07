import 'package:dental_app/core/api/end_points.dart';

/// Helpers for patient `profileImage` from the API.
class PatientProfileImage {
  PatientProfileImage._();

  /// Raw URL from patient map (`profileImage.url`), or null if missing.
  static String? urlOf(Map<String, dynamic>? patient) {
    if (patient == null) return null;
    final profileImage = patient['profileImage'];
    if (profileImage is Map) {
      final url = profileImage['url']?.toString().trim();
      if (url != null && url.isNotEmpty) return url;
    }
    return null;
  }

  /// Absolute URL for NetworkImage / Image.network.
  static String? resolve(String? url) {
    final raw = url?.trim();
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;

    final base = EndPoints.baserUrl;
    final origin = base.replaceFirst(RegExp(r'/api/v1/?$'), '');
    if (raw.startsWith('/')) return '$origin$raw';
    return '$origin/$raw';
  }
}
