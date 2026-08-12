import 'package:easy_localization/easy_localization.dart';

String resolveChatbotFailure({
  required String? code,
  required String fallback,
  int? statusCode,
}) {
  if (statusCode == 0) {
    return 'No Internet Connection'.tr();
  }
  return mapChatbotError(code, fallback);
}

String mapChatbotError(String? code, String fallback) {
  switch (code) {
    case 'CHATBOT_UNAVAILABLE':
      return 'The chatbot is currently unavailable. You can enter the visit reason manually'
          .tr();
    case 'CHATBOT_TURN_LIMIT':
      return 'This conversation has reached the maximum number of messages'.tr();
    case 'CHATBOT_SUMMARIZE_INVALID':
      return 'Could not summarize the conversation. Retry or enter the reason manually'
          .tr();
    default:
      return fallback;
  }
}
