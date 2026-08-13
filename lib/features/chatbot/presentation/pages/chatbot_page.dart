import 'package:dental_app/core/utils/clinic_contact.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/chatbot/data/models/chatbot_api_mode.dart';
import 'package:dental_app/features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

/// وضع الشاشة:
/// - [home]: محادثة عامة (EDUCATION).
/// - [booking]: محادثة ضمن مسار الحجز (TRIAGE) + summarize.
enum ChatbotMode { home, booking }

/// شاشة محادثة المريض مع المساعد الذكي — مربوطة مع الباك عبر [ChatbotBloc].
class ChatbotPage extends StatelessWidget {
  final ChatbotMode mode;

  const ChatbotPage({super.key, this.mode = ChatbotMode.home});

  ChatbotApiMode get _apiMode =>
      mode == ChatbotMode.booking
          ? ChatbotApiMode.triage
          : ChatbotApiMode.education;

  bool get _isBooking => mode == ChatbotMode.booking;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatbotBloc()
        ..add(ChatbotSessionStarted(apiMode: _apiMode)),
      child: _ChatbotView(isBooking: _isBooking),
    );
  }
}

class _ChatbotView extends StatefulWidget {
  final bool isBooking;

  const _ChatbotView({required this.isBooking});

  @override
  State<_ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<_ChatbotView> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    context.read<ChatbotBloc>().add(ChatMessageSendRequested(message: text));
    _inputController.clear();
    _scrollToBottom();
  }

  void _extractDiagnosis() {
    context.read<ChatbotBloc>().add(ChatSummarizeRequested());
  }

  void _onBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocConsumer<ChatbotBloc, ChatbotState>(
      listener: (context, state) {
        if (state is ChatbotSessionActive) {
          if (state.completedSummary != null) {
            Navigator.of(context).pop(state.completedSummary);
            return;
          }
          _scrollToBottom();
        } else if (state is ChatMessageSendFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMessage)),
          );
          if (state.unavailable && widget.isBooking) {
            Navigator.of(context).pop();
          }
        } else if (state is ChatSummarizeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMessage)),
          );
        }
      },
      buildWhen: (previous, current) =>
          current is ChatbotSessionActive ||
          current is ChatbotInitial ||
          current is ChatMessageSendFailure ||
          current is ChatSummarizeFailure,
      builder: (context, state) {
        ChatbotSessionActive? session;
        if (state is ChatbotSessionActive) {
          session = state;
        } else if (state is ChatMessageSendFailure) {
          session = state.session;
        } else if (state is ChatSummarizeFailure) {
          session = state.session;
        }

        final isSending = session?.isSending ?? false;
        final isSummarizing = session?.isSummarizing ?? false;
        final messages = session?.messages ?? [];
        final canExtract = session?.canSummarize ?? false;
        final canSend = session?.canSend ?? false;
        final isEmergency = session?.isEmergency ?? false;
        final unavailable = session?.unavailable ?? false;

        return Scaffold(
          backgroundColor: colors.surfaceContainerHighest,
          appBar: AppBar(
            backgroundColor: colors.surfaceContainerHighest,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_forward, color: colors.onSurface),
              onPressed: isSummarizing ? null : _onBack,
            ),
            title: Text(
              widget.isBooking ? 'Smart Diagnosis'.tr() : 'Dental Assistant'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    if (isEmergency)
                      _EmergencyBanner(
                        onContact: () async {
                          final opened = await ClinicContact.openWhatsApp();
                          if (!opened && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please contact the clinic immediately for urgent care.'
                                      .tr(),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    if (unavailable && !widget.isBooking)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Text(
                          'The chatbot is currently unavailable. You can enter the visit reason manually'
                              .tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: colors.error,
                            height: 1.4,
                          ),
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        itemCount: messages.length + (isSending ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == messages.length) {
                            return const _TypingBubble();
                          }
                          final message = messages[index];
                          return FadeSlideIn(
                            duration: const Duration(milliseconds: 250),
                            child: _ChatBubble(message: message),
                          );
                        },
                      ),
                    ),
                    if (widget.isBooking)
                      _ExtractDiagnosisBar(
                        enabled: canExtract,
                        forcedByLimit: session?.forcedByLimit ?? false,
                        onTap: _extractDiagnosis,
                      ),
                    _ChatInputBar(
                      controller: _inputController,
                      onSend: _sendMessage,
                      enabled: canSend,
                    ),
                  ],
                ),
                if (isSummarizing)
                  Positioned.fill(
                    child: ColoredBox(
                      color: colors.scrim.withOpacity(0.25),
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 22,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 36,
                                height: 36,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: colors.primary,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Extracting diagnosis...'.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: colors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  final VoidCallback onContact;

  const _EmergencyBanner({required this.onContact});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.errorContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: colors.error, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Your symptoms may need urgent attention. Please contact the clinic.'
                    .tr(),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: colors.onErrorContainer,
                  height: 1.35,
                ),
              ),
            ),
            TextButton(
              onPressed: onContact,
              child: Text('Contact'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExtractDiagnosisBar extends StatelessWidget {
  final bool enabled;
  final bool forcedByLimit;
  final VoidCallback onTap;

  const _ExtractDiagnosisBar({
    required this.enabled,
    required this.forcedByLimit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!enabled && !forcedByLimit)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Keep chatting until the assistant has enough information.'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: colors.onSurface.withOpacity(0.45),
                ),
              ),
            ),
          if (forcedByLimit)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Conversation limit reached. Please extract the diagnosis to continue.'
                    .tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: enabled ? onTap : null,
              icon: Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: enabled ? Colors.white : colors.onSurface.withOpacity(0.35),
              ),
              label: Text(
                'End conversation & extract diagnosis'.tr(),
                style: TextStyle(
                  color: enabled
                      ? Colors.white
                      : colors.onSurface.withOpacity(0.35),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                disabledBackgroundColor: colors.onSurface.withOpacity(0.08),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatUiMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isBot = message.isBot;

    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: message.isSystem
            ? colors.errorContainer.withOpacity(0.55)
            : (isBot ? colors.surface : colors.primary),
        borderRadius: BorderRadiusDirectional.only(
          topStart: const Radius.circular(16),
          topEnd: const Radius.circular(16),
          bottomStart: Radius.circular(isBot ? 16 : 4),
          bottomEnd: Radius.circular(isBot ? 4 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        message.isSystem ? message.text.tr() : message.text,
        style: TextStyle(
          fontSize: 13.5,
          height: 1.5,
          color: message.isSystem
              ? colors.onErrorContainer
              : (isBot ? colors.onSurface : Colors.white),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: isBot
            ? AlignmentDirectional.centerStart
            : AlignmentDirectional.centerEnd,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: isBot
              ? [
                  if (!message.isSystem) const _BotAvatar(),
                  if (!message.isSystem) const SizedBox(width: 8),
                  Flexible(child: bubble),
                ]
              : [Flexible(child: bubble)],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const _BotAvatar(),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(16),
                  topEnd: Radius.circular(16),
                  bottomEnd: Radius.circular(4),
                  bottomStart: Radius.circular(16),
                ),
              ),
              child: SizedBox(
                width: 28,
                height: 12,
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: colors.onSurface.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotAvatar extends StatelessWidget {
  const _BotAvatar();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 32,
      height: 32,
      child: Lottie.asset(
        'assets/animations/ai_bot_dental.json',
        repeat: true,
        errorBuilder: (context, error, stackTrace) => Container(
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.smart_toy_outlined,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;

  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        border: Border(
          top: BorderSide(color: colors.outline.withOpacity(0.12)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                enabled: enabled,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: enabled ? (_) => onSend() : null,
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Type your message here...'.tr(),
                  hintStyle: TextStyle(
                    color: colors.onSurface.withOpacity(0.4),
                    fontSize: 13.5,
                  ),
                ),
                style: const TextStyle(fontSize: 13.5),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: enabled
                  ? colors.primary
                  : colors.primary.withOpacity(0.35),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: enabled ? onSend : null,
              icon: const Icon(
                Icons.send_rounded,
                size: 19,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
