class ChatbotMessageResponse {
  final String? reply;
  final bool readyForSummary;
  final bool forcedByLimit;
  final bool isEmergency;
  final String? interactionId;

  const ChatbotMessageResponse({
    required this.reply,
    required this.readyForSummary,
    required this.forcedByLimit,
    this.isEmergency = false,
    this.interactionId,
  });

  factory ChatbotMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotMessageResponse(
      reply: json['reply'] as String?,
      readyForSummary: json['readyForSummary'] as bool? ?? false,
      forcedByLimit: json['forcedByLimit'] as bool? ?? false,
      isEmergency: json['isEmergency'] as bool? ?? false,
      interactionId: json['interactionId'] as String?,
    );
  }
}
