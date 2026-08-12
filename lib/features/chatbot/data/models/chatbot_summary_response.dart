class ChatbotSummaryResponse {
  final String summary;

  const ChatbotSummaryResponse({required this.summary});

  factory ChatbotSummaryResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotSummaryResponse(
      summary: json['summary'] as String? ?? '',
    );
  }
}
