import 'package:dental_app/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// كارد "خطتك العلاجية النشطة". بيانات تجريبية حالياً (TODO: وصلها
/// بالخطة الفعلية النشطة للمريض لما يجهز الـ backend).
class ActiveTreatmentPlanCard extends StatelessWidget {
  final String planName;
  final int currentSession;
  final int totalSessions;
  final double progress; // 0..1
  final VoidCallback onViewDetails;

  const ActiveTreatmentPlanCard({
    super.key,
    required this.planName,
    required this.currentSession,
    required this.totalSessions,
    required this.progress,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    // مفيش لون "بني/كهرماني" جاهز بالـ AppColors، فاستخدمت accent
    // (الذهبي) مع تغميقه للنص حتى يقرا منيح - نفس تقنية readableAccent
    // يلي استخدمناها بشاشة تأكيد الحجز.
    final badgeColor = Color.alphaBlend(
      Colors.black.withOpacity(0.30),
      AppColors.accent,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(isDark ? 0.30 : 0.10),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(
      child: Text(
        'Your Active Treatment Plan'.tr(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: colors.onSurface,
        ),
      ),
    ),
    const SizedBox(width: 8),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Session {current} of {total}'.tr(
          namedArgs: {
            'current': '$currentSession',
            'total': '$totalSessions',
          },
        ),
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: badgeColor,
        ),
      ),
    ),
  ],
),
const SizedBox(height: 4),
Text(
  planName,
  style: TextStyle(
    fontSize: 13,
    color: colors.onSurface.withOpacity(0.6),
  ),
),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              Text(
                'Completion Rate'.tr(),
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurface.withOpacity(0.55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
               backgroundColor: colors.primary.withOpacity(0.15),
valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onViewDetails,
              icon: const Icon(Icons.arrow_back, size: 15),
              label: Text('Treatment Plan Details'.tr()),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.primary,
                side: BorderSide(color: colors.primary.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(vertical: 12),
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
