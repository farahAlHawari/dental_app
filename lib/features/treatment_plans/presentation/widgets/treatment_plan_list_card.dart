import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_invoice.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan_status.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// كارد خطة بالقائمة — اسم + حالة + بادج جلسة + شريط تقدم + تكلفة تقديرية.
class TreatmentPlanListCard extends StatelessWidget {
  final TreatmentPlan plan;
  final VoidCallback? onViewDetails;

  const TreatmentPlanListCard({
    super.key,
    required this.plan,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeColor = Color.alphaBlend(
      Colors.black.withOpacity(0.30),
      AppColors.accent,
    );
    final name = plan.name.isEmpty ? 'Treatment plan'.tr() : plan.name;
    final cost = plan.estimatedCost?.trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onViewDetails,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(22),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _PlanStatusBadge(status: plan.status),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Session {current} of {total}'.tr(
                        namedArgs: {
                          'current': '${plan.currentSession}',
                          'total': '${plan.sessionCount}',
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${plan.progressPercent}%',
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
                child: SizedBox(
                  height: 8,
                  child: Stack(
                    children: [
                      Container(color: colors.primary.withOpacity(0.15)),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: plan.progress),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) => FractionallySizedBox(
                          alignment: AlignmentDirectional.centerStart,
                          widthFactor: value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [colors.primary, colors.secondary],
                                begin: AlignmentDirectional.centerStart,
                                end: AlignmentDirectional.centerEnd,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (cost != null && cost.isNotEmpty) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 16,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Estimated cost'.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface.withOpacity(0.65),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      planMoney(cost),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanStatusBadge extends StatelessWidget {
  final TreatmentPlanStatus status;

  const _PlanStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color bg;
    final Color fg;

    switch (status) {
      case TreatmentPlanStatus.completed:
        bg = AppColors.success.withOpacity(0.12);
        fg = AppColors.success;
      case TreatmentPlanStatus.cancelled:
        bg = colors.onSurface.withOpacity(0.06);
        fg = colors.onSurface.withOpacity(0.5);
      case TreatmentPlanStatus.active:
        bg = colors.primary.withOpacity(0.12);
        fg = colors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.labelKey.tr(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
