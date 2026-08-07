import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// وضع الشات بوت:
/// - [home]: محادثة عامة من الرئيسية (لوجيك مختلف لاحقاً).
/// - [booking]: محادثة ضمن مسار حجز الاستشارة — كل حجز = شات جديدة،
///   وزر إنهاء مرتبط بفلَاغ من الباك (هلق mock).
enum ChatbotMode { home, booking }

class _ChatMessage {
  final String text;
  final bool isBot;

  const _ChatMessage({required this.text, required this.isBot});
}

/// شاشة محادثة المريض مع المساعد الذكي.
///
/// بوضع [ChatbotMode.booking]:
/// 1) كل رسالة → ريكوست 1 للباك (mock) → رد البوت + احتمال فلَاغ
///    `canExtractDiagnosis`.
/// 2) لما الفلَاغ true → زر "إنهاء المحادثة واستخراج التشخيص" enable.
/// 3) ضغط الزر → ريكوست 2 (mock) → ملخص يرجع لشاشة سبب الزيارة.
///
/// ما في تخزين محادثات — كل فتح = شات جديدة من الصفر.
class ChatbotPage extends StatefulWidget {
  final ChatbotMode mode;

  const ChatbotPage({super.key, this.mode = ChatbotMode.home});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(text: 'Hello! How can I help you today?', isBot: true),
  ];

  bool _isTyping = false;
  bool _isExtracting = false;

  /// بيجي من الباك مع رد البوت لما الإيجنت صار عنده كفاية معلومات.
  /// TODO: ربط مع الـ API الحقيقي.
  bool _canExtractDiagnosis = false;

  /// عدد رسائل المريض — mock لمتى نفعّل الفلَاغ (بعد رسالتين).
  int _patientMessageCount = 0;

  bool get _isBooking => widget.mode == ChatbotMode.booking;

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

  /// ريكوست 1 (mock): إرسال رسالة المريض واستلام رد البوت + الفلَاغ.
  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isTyping || _isExtracting) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isBot: false));
      _patientMessageCount++;
      _isTyping = true;
    });
    _inputController.clear();
    _scrollToBottom();

    // TODO: استبدال بـ API call حقيقي:
    // POST /chat/message { message, sessionId? } → { reply, canExtractDiagnosis }
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final unlockDiagnosis = _isBooking && _patientMessageCount >= 2;
    final replyKey = unlockDiagnosis && !_canExtractDiagnosis
        ? 'I think I have enough information. You can end the chat to extract your diagnosis.'
        : 'Thanks for sharing that. Can you tell me more?';

    setState(() {
      _isTyping = false;
      _messages.add(_ChatMessage(text: replyKey, isBot: true));
      if (unlockDiagnosis) {
        _canExtractDiagnosis = true;
      }
    });
    _scrollToBottom();
  }

  /// ريكوست 2 (mock): إنهاء المحادثة واستخراج ملخص التشخيص من الباك.
  Future<void> _extractDiagnosis() async {
    if (!_canExtractDiagnosis || _isExtracting) return;

    setState(() => _isExtracting = true);

    // TODO: استبدال بـ API call حقيقي:
    // POST /chat/end { messages / sessionId } → { summary }
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final patientParts = _messages
        .where((m) => !m.isBot)
        .map((m) => m.text)
        .join(' — ');

    final summary = patientParts.isEmpty
        ? 'Suspected dental concern based on the consultation chat.'.tr()
        : '${'Patient reported'.tr()}: $patientParts. ${'Preliminary assessment pending clinical exam.'.tr()}';

    Navigator.of(context).pop(summary);
  }

  void _onBack() {
    // الرجوع بدون إنهاء رسمي — ما منبعت ريكوست 2 وما منرجّع ملخص.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: colors.surfaceContainerHighest,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_forward, color: colors.onSurface),
          onPressed: _isExtracting ? null : _onBack,
        ),
        title: Text(
          'Smart Diagnosis'.tr(),
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
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return const _TypingBubble();
                      }
                      final message = _messages[index];
                      return FadeSlideIn(
                        duration: const Duration(milliseconds: 250),
                        child: _ChatBubble(message: message),
                      );
                    },
                  ),
                ),
                if (_isBooking)
                  _ExtractDiagnosisBar(
                    enabled: _canExtractDiagnosis && !_isExtracting,
                    onTap: _extractDiagnosis,
                  ),
                _ChatInputBar(
                  controller: _inputController,
                  onSend: _sendMessage,
                  enabled: !_isExtracting,
                ),
              ],
            ),
            if (_isExtracting)
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
  }
}

/// زر إنهاء المحادثة واستخراج التشخيص — معطّل لحد ما يجي الفلَاغ من الباك.
class _ExtractDiagnosisBar extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _ExtractDiagnosisBar({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!enabled)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Keep chatting until the assistant has enough information.'
                    .tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: colors.onSurface.withOpacity(0.45),
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
                color: enabled
                    ? Colors.white
                    : colors.onSurface.withOpacity(0.35),
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
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isBot = message.isBot;

    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isBot ? colors.surface : colors.primary,
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
        message.text.tr(),
        style: TextStyle(
          fontSize: 13.5,
          height: 1.5,
          color: isBot ? colors.onSurface : Colors.white,
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
                  const _BotAvatar(),
                  const SizedBox(width: 8),
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
