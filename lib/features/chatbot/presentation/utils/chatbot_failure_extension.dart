import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/chatbot/presentation/utils/chatbot_error_messages.dart';

extension ChatbotFailureX on Failure {
  String get displayMessage => resolveChatbotFailure(
        code: code,
        fallback: errMessage,
        statusCode: statusCode,
      );
}
