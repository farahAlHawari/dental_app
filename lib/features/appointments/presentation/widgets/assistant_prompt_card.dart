import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// كرت "المساعد الذكي" يلي بيطلع فوق التيكست بوكس مباشرة.
/// زر واحد لفتح الشات (أو متابعة المحادثة). الملخص بيتعبّى بالتيكست
/// فيلد تلقائياً لما المريض ينهي المحادثة من جوا البوت — ما عاد في
/// حاجة لزر "استخدام الملخص" المنفصل.
/// حول الكارد حلقة خفيفة "نابضة" (glow) لتوحي إنه مدعوم بذكاء اصطناعي.
class AssistantPromptCard extends StatefulWidget {
  final bool hasChatSummary;
  final VoidCallback onStartChat;

  const AssistantPromptCard({
    super.key,
    required this.hasChatSummary,
    required this.onStartChat,
  });

  @override
  State<AssistantPromptCard> createState() => _AssistantPromptCardState();
}

class _AssistantPromptCardState extends State<AssistantPromptCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final glow = _glowController.value; // 0..1، رايح جاي بسبب reverse:true
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colors.primary.withOpacity(0.12 + glow * 0.18),
              width: 1.4,
            ),
            boxShadow: [
              // ظل عادي هادي (نفس منطق كارد نوع الزيارة عندك:
              // opacity حسب الوضع الليلي/النهاري)
              BoxShadow(
                color: colors.shadow.withOpacity(isDark ? 0.30 : 0.10),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
              // الظل الثاني هو الـ "glow" النابض
              BoxShadow(
                color: colors.primary.withOpacity(0.05 + glow * 0.10),
                blurRadius: 18 + glow * 10,
                spreadRadius: glow * 1.5,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TODO: حطي هون مسار الـ Lottie يلي رح تختاريه، مثلاً
              // assets/animations/chat_assistant.json (وضيفيه بمجلد
              // assets/animations - هو مسجل بالـ pubspec أصلاً).
              // لحد ما تختاريه، الـ errorBuilder بيبين أيقونة بديلة
              // فالشاشة ما بتنكسر.
              SizedBox(
                width: 64,
                height: 64,
                child: Lottie.asset(
                  'assets/animations/ai_bot_dental.json',
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.smart_toy_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 34,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Not sure what's wrong?".tr(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chat with our assistant — it will ask you a few simple questions.'
                          .tr(),
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: widget.onStartChat,
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
            label: Text(
              widget.hasChatSummary
                  ? 'Continue chatting'.tr()
                  : 'Chat with assistant'.tr(),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
