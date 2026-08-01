import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// بطاقة "تحدث مع مساعدك الذكي" الرئيسية.
class AssistantHeroCard extends StatefulWidget {
  final VoidCallback onStartChat;

  const AssistantHeroCard({super.key, required this.onStartChat});

  @override
  State<AssistantHeroCard> createState() => _AssistantHeroCardState();
}

class _AssistantHeroCardState extends State<AssistantHeroCard>
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
    // لون غامق ثابت (مش تابع للايت/دارك) حتى النص الأبيض يضل واضح
    // بالحالتين - نفس فكرة تغميق الـ accent يلي عملناها بشاشة التأكيد.
    final heroColor = Color.alphaBlend(
      Colors.black.withOpacity(0.35),
      colors.primary,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: heroColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: heroColor.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final glow = _glowController.value;
        return Container(
          width: 68,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16 + glow * 0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Lottie.asset(
          'assets/animations/Ai_Robot.json',
          repeat: true,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.smart_toy_outlined,
            color: Colors.white,
            size: 34,
          ),
        ),
      ),
    ),
    const SizedBox(width: 14),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chat with your personal smart assistant'.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Ask any medical question, describe your pain, or report your concern instantly.'
                .tr(),
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    ),
  ],
),
         
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onStartChat,
              icon: const Icon(Icons.auto_awesome_rounded, size: 17),
              label: Text('Start chatting now'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: heroColor,
                padding: const EdgeInsets.symmetric(vertical: 13),
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
