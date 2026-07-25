import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> openWhatsApp({
    required String phone,
    String? message,
  }) async {
    final url = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message ?? '')}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw Exception("Could not open WhatsApp");
    }
  }
}