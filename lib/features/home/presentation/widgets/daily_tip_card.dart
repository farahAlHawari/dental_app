import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// كارد "نصيحة يومية" - كارد خفيف (مش hero) بيعرض نصيحة عن صحة الأسنان.
/// بيبدأ بنصيحة اليوم (حسب رقم اليوم بالسنة، بلا ما يحتاج backend)، بس
/// فيه زر تحديث صغير حتى يقدر المريض يتصفح باقي النصايح لما يحب - لمسة
/// تفاعلية بسيطة حتى الكارد ما يحس "ساكن وناشف". مكانه بالرئيسية بين
/// كارد الموعد القادم وكارد المساعد الذكي (أو أول عنصر إذا مفيش موعد
/// قادم) - شوف [HomePage].
class DailyTipCard extends StatefulWidget {
  const DailyTipCard({super.key});

  @override
  State<DailyTipCard> createState() => _DailyTipCardState();
}

class _DailyTipCardState extends State<DailyTipCard>
    with SingleTickerProviderStateMixin {
  static const List<String> _tips = [
    'Brush your teeth for at least two minutes, twice a day.',
    'Replace your toothbrush every 3 months for the best results.',
    "Flossing daily helps remove plaque brushing alone can't reach.",
    'Limit sugary snacks and drinks to protect your enamel.',
    'Rinsing with water after meals helps reduce acid buildup.',
    'Visit your dentist every 6 months for a routine checkup.',
    'Chewing sugar-free gum can help stimulate saliva and protect your teeth.',
    'Drink plenty of water to keep your mouth clean and hydrated.',
  ];

  late int _tipIndex;
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    _tipIndex = dayOfYear % _tips.length;
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

  void _showNextTip() {
    setState(() => _tipIndex = (_tipIndex + 1) % _tips.length);
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
        child: Stack(
          children: [
            // أيقونة زخرفية كبيرة باهتة بزاوية الكارد - لمسة "شخصية" بلا
            // ما تزاحم النص.
            Positioned(
              right: -16,
              bottom: -20,
              child: Icon(
                Icons.local_hospital_rounded,
                size: 92,
                color: colors.primary.withOpacity(0.06),
              ),
            ),
            Padding(
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
                          color: colors.primary.withOpacity(
                            0.12 + glow * 0.10,
                          ),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Daily Dental Tip'.tr(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurface,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _showNextTip,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: colors.primary.withOpacity(0.10),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.refresh_rounded,
                                  size: 14,
                                  color: colors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _tips[_tipIndex].tr(),
                            key: ValueKey<int>(_tipIndex),
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              color: colors.onSurface.withOpacity(0.72),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
