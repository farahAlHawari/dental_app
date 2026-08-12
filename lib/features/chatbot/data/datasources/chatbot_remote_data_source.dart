import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';
import 'package:dental_app/features/chatbot/data/models/chatbot_api_mode.dart';
import 'package:dental_app/features/chatbot/data/models/chatbot_message_response.dart';
import 'package:dental_app/features/chatbot/data/models/chatbot_summary_response.dart';

class ChatbotRemoteDataSource {
  final DioConsumer api;

  ChatbotRemoteDataSource({required this.api});

  Future<ChatbotMessageResponse> sendMessage({
    required ChatbotApiMode mode,
    required String message,
    required int turnCount,
    String? previousInteractionId,
  }) async {
    final body = <String, dynamic>{
      'mode': mode.apiValue,
      'message': message,
      'turnCount': turnCount,
    };
    if (previousInteractionId != null && previousInteractionId.isNotEmpty) {
      body['previousInteractionId'] = previousInteractionId;
    }

    final response = await api.post(EndPoints.chatbotMessage, data: body);
    final data = _extractData(response);
    if (data == null) {
      throw StateError('Empty chatbot message response');
    }
    return ChatbotMessageResponse.fromJson(data);
  }

  Future<ChatbotSummaryResponse> summarize({
    required String previousInteractionId,
  }) async {
    final response = await api.post(
      EndPoints.chatbotSummarize,
      data: {'previousInteractionId': previousInteractionId},
    );
    final data = _extractData(response);
    if (data == null) {
      throw StateError('Empty chatbot summarize response');
    }
    return ChatbotSummaryResponse.fromJson(data);
  }

  Map<String, dynamic>? _extractData(dynamic response) {
    if (response is! Map) return null;
    final data = Map<String, dynamic>.from(response)['data'];
    if (data == null) return null;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }
}
