import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class WhatsAppService {
  static Future<void> openWhatsApp({
    required String phone,
    String? message,
  }) async {
    final encodedMessage = Uri.encodeComponent(message ?? '');

   
    final whatsappUrl = Uri.parse("whatsapp://send?phone=$phone&text=$encodedMessage");

    try {
      final launched = await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        
        final fallbackUrl = Uri.parse("https://wa.me/$phone?text=$encodedMessage");
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("WhatsApp launch error: $e");
      throw Exception("Could not open WhatsApp");
    }
  }
}