import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/chatbot/data/models/chatbot_api_mode.dart';
import 'package:dental_app/features/chatbot/data/models/chatbot_message_response.dart';
import 'package:dental_app/features/chatbot/data/models/chatbot_summary_response.dart';

abstract class ChatbotRepository {
  Future<Either<Failure, ChatbotMessageResponse>> sendMessage({
    required ChatbotApiMode mode,
    required String message,
    required int turnCount,
    String? previousInteractionId,
  });

  Future<Either<Failure, ChatbotSummaryResponse>> summarize({
    required String previousInteractionId,
  });
}
