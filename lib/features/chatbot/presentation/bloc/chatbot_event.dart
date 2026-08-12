part of 'chatbot_bloc.dart';

@immutable
sealed class ChatbotEvent {}

final class ChatbotSessionStarted extends ChatbotEvent {
  final ChatbotApiMode apiMode;

  ChatbotSessionStarted({required this.apiMode});
}

final class ChatMessageSendRequested extends ChatbotEvent {
  final String message;

  ChatMessageSendRequested({required this.message});
}

final class ChatSummarizeRequested extends ChatbotEvent {}
