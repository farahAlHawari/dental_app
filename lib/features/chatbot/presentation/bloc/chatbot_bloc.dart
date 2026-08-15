import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/features/chatbot/data/datasources/chatbot_remote_data_source.dart';
import 'package:dental_app/features/chatbot/data/models/chatbot_api_mode.dart';
import 'package:dental_app/features/chatbot/domain/repositories/chatbot_repository_impl.dart';
import 'package:dental_app/features/chatbot/presentation/utils/chatbot_failure_extension.dart';
import 'package:dental_app/features/chatbot/presentation/utils/chatbot_summary_parser.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';

part 'chatbot_event.dart';
part 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final _repository = ChatbotRepositoryImpl(
    remoteDataSource: ChatbotRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  ChatbotBloc() : super(ChatbotInitial()) {
    on<ChatbotSessionStarted>(_onSessionStarted);
    on<ChatMessageSendRequested>(_onSendMessage);
    on<ChatSummarizeRequested>(_onSummarize);
  }

  void _onSessionStarted(
    ChatbotSessionStarted event,
    Emitter<ChatbotState> emit,
  ) {
    final welcome = event.apiMode == ChatbotApiMode.triage
        ? "Please describe what you're experiencing so I can help diagnose it."
            .tr()
        : "Hello, I'm your smart medical assistant. How can I help you?".tr();

    emit(
      ChatbotSessionActive(
        apiMode: event.apiMode,
        messages: [
          ChatUiMessage(
            text: welcome,
            isBot: true,
          ),
        ],
        turnCount: 0,
      ),
    );
  }

  Future<void> _onSendMessage(
    ChatMessageSendRequested event,
    Emitter<ChatbotState> emit,
  ) async {
    final current = state;
    if (current is! ChatbotSessionActive || !current.canSend) return;

    final text = event.message.trim();
    if (text.isEmpty) return;

    final sending = current.copyWith(
      messages: [
        ...current.messages,
        ChatUiMessage(text: text, isBot: false),
      ],
      isSending: true,
    );
    emit(sending);

    final result = await _repository.sendMessage(
      mode: current.apiMode,
      message: text,
      turnCount: current.turnCount,
      previousInteractionId: current.interactionId,
    );

    result.fold(
      (failure) {
        final unavailable = failure.code == 'CHATBOT_UNAVAILABLE';
        final session = sending.copyWith(isSending: false, unavailable: unavailable);
        emit(
          ChatMessageSendFailure(
            session: session,
            errMessage: failure.displayMessage,
            unavailable: unavailable,
          ),
        );
        emit(session);
      },
      (response) {
        final messages = List<ChatUiMessage>.from(sending.messages);

        if (response.reply != null && response.reply!.trim().isNotEmpty) {
          messages.add(ChatUiMessage(text: response.reply!.trim(), isBot: true));
        }

        if (response.forcedByLimit) {
          messages.add(
            ChatUiMessage(
              text: 'This conversation has reached the maximum number of messages'
                  .tr(),
              isBot: true,
              isSystem: true,
            ),
          );
        }

        emit(
          sending.copyWith(
            messages: messages,
            turnCount: current.turnCount + 1,
            interactionId: response.interactionId ?? current.interactionId,
            readyForSummary: response.readyForSummary,
            forcedByLimit: response.forcedByLimit,
            isEmergency: response.isEmergency,
            isSending: false,
          ),
        );
      },
    );
  }

  Future<void> _onSummarize(
    ChatSummarizeRequested event,
    Emitter<ChatbotState> emit,
  ) async {
    final current = state;
    if (current is! ChatbotSessionActive || !current.canSummarize) return;

    final interactionId = current.interactionId;
    if (interactionId == null || interactionId.isEmpty) return;

    emit(current.copyWith(isSummarizing: true));

    final result = await _repository.summarize(
      previousInteractionId: interactionId,
    );

    result.fold(
      (failure) {
        final session = current.copyWith(isSummarizing: false);
        emit(
          ChatSummarizeFailure(
            session: session,
            errMessage: failure.displayMessage,
          ),
        );
        emit(session);
      },
      (response) {
        final summary = normalizeChatbotSummary(response.summary);
        if (summary.isEmpty) {
          final session = current.copyWith(isSummarizing: false);
          emit(
            ChatSummarizeFailure(
              session: session,
              errMessage:
                  'Keep chatting until the assistant has enough information.'
                      .tr(),
            ),
          );
          emit(session);
          return;
        }
        emit(
          current.copyWith(
            isSummarizing: false,
            completedSummary: summary,
          ),
        );
      },
    );
  }
}
