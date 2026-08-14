import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_invoice.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan_status.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TreatmentPlanHeroCard extends StatelessWidget {
  final TreatmentPlan plan;

  const TreatmentPlanHeroCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = plan.name.isEmpty ? 'Treatment plan'.tr() : plan.name;
    final cost = plan.displayCost;

    return Container(
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
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: plan.status),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '{percent}% completed'.tr(
                  namedArgs: {'percent': '${plan.progressPercent}'},
                ),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                'Session {current} of {total}'.tr(
                  namedArgs: {
                    'current': '${plan.currentSession}',
                    'total': '${plan.sessionCount}',
                  },
                ),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface.withOpacity(0.55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest.withOpacity(0.65),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 18,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    plan.displayCostLabelKey.tr(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    planMoney(cost),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final TreatmentPlanStatus status;

  const _StatusBadge({required this.status});

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.labelKey.tr(),
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
