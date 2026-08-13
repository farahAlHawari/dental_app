import 'package:url_launcher/url_launcher.dart';

/// Shared clinic contact helpers for Emergency / chatbot Contact / QR help.
class ClinicContact {
  ClinicContact._();

  /// Clinic WhatsApp / phone (digits only, country code included).
  static const String whatsAppNumber = '963959296517';

  static Uri get whatsAppUri => Uri.parse('https://wa.me/$whatsAppNumber');

  static Uri get phoneUri => Uri.parse('tel:+$whatsAppNumber');

  static Future<bool> openWhatsApp() => _launch(whatsAppUri);

  static Future<bool> openPhone() => _launch(phoneUri);

  static Future<bool> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
