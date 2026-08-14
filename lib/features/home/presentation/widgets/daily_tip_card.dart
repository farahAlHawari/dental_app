import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// كارد "نصيحة يومية" ثابتة بالرئيسية — نص أطول وخط أوضح، بدون تبديل.
class DailyTipCard extends StatefulWidget {
  const DailyTipCard({super.key});

  @override
  State<DailyTipCard> createState() => _DailyTipCardState();
}

class _DailyTipCardState extends State<DailyTipCard>
    with SingleTickerProviderStateMixin {
  static const String _tipKey =
      'Brush twice a day for two minutes, floss daily, and limit sugar to protect your enamel. A checkup every six months helps catch problems early.';

  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
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

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.tertiary.withOpacity(0.24),
            colors.primary.withOpacity(0.07),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.tertiary.withOpacity(0.35)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  final glow = _glowController.value;
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary.withOpacity(0.12 + glow * 0.10),
                    ),
                    child: child,
                  );
                },
                child: Icon(
                  Icons.tips_and_updates_rounded,
                  color: colors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Dental Tip'.tr(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _tipKey.tr(),
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: colors.onSurface.withOpacity(0.78),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
