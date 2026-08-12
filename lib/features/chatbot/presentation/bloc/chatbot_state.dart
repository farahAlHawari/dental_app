part of 'chatbot_bloc.dart';

@immutable
class ChatUiMessage {
  final String text;
  final bool isBot;
  final bool isSystem;

  const ChatUiMessage({
    required this.text,
    required this.isBot,
    this.isSystem = false,
  });
}

@immutable
sealed class ChatbotState {}

final class ChatbotInitial extends ChatbotState {}

final class ChatbotSessionActive extends ChatbotState {
  final ChatbotApiMode apiMode;
  final List<ChatUiMessage> messages;
  final int turnCount;
  final String? interactionId;
  final bool readyForSummary;
  final bool forcedByLimit;
  final bool unavailable;
  final bool isSending;
  final bool isSummarizing;
  final bool isEmergency;
  final String? completedSummary;

  ChatbotSessionActive({
    required this.apiMode,
    required this.messages,
    required this.turnCount,
    this.interactionId,
    this.readyForSummary = false,
    this.forcedByLimit = false,
    this.unavailable = false,
    this.isSending = false,
    this.isSummarizing = false,
    this.isEmergency = false,
    this.completedSummary,
  });

  bool get canSend =>
      !isSending &&
      !isSummarizing &&
      !forcedByLimit &&
      !unavailable &&
      completedSummary == null;

  bool get canSummarize =>
      apiMode == ChatbotApiMode.triage &&
      interactionId != null &&
      interactionId!.isNotEmpty &&
      (readyForSummary || forcedByLimit) &&
      !isSummarizing &&
      completedSummary == null &&
      !unavailable;

  ChatbotSessionActive copyWith({
    ChatbotApiMode? apiMode,
    List<ChatUiMessage>? messages,
    int? turnCount,
    String? interactionId,
    bool? readyForSummary,
    bool? forcedByLimit,
    bool? unavailable,
    bool? isSending,
    bool? isSummarizing,
    bool? isEmergency,
    String? completedSummary,
    bool clearCompletedSummary = false,
    bool clearInteractionId = false,
  }) {
    return ChatbotSessionActive(
      apiMode: apiMode ?? this.apiMode,
      messages: messages ?? this.messages,
      turnCount: turnCount ?? this.turnCount,
      interactionId:
          clearInteractionId ? null : interactionId ?? this.interactionId,
      readyForSummary: readyForSummary ?? this.readyForSummary,
      forcedByLimit: forcedByLimit ?? this.forcedByLimit,
      unavailable: unavailable ?? this.unavailable,
      isSending: isSending ?? this.isSending,
      isSummarizing: isSummarizing ?? this.isSummarizing,
      isEmergency: isEmergency ?? this.isEmergency,
      completedSummary: clearCompletedSummary
          ? null
          : completedSummary ?? this.completedSummary,
    );
  }
}

final class ChatMessageSendFailure extends ChatbotState {
  final ChatbotSessionActive session;
  final String errMessage;
  final bool unavailable;

  ChatMessageSendFailure({
    required this.session,
    required this.errMessage,
    this.unavailable = false,
  });
}

final class ChatSummarizeFailure extends ChatbotState {
  final ChatbotSessionActive session;
  final String errMessage;

  ChatSummarizeFailure({
    required this.session,
    required this.errMessage,
  });
}
