import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_session_status.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SessionStatusBadge extends StatelessWidget {
  final PlanSession session;

  const SessionStatusBadge({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color bg;
    final Color fg;

    if (session.isBookablePending) {
      bg = AppColors.accent.withOpacity(0.18);
      fg = Color.alphaBlend(Colors.black.withOpacity(0.35), AppColors.accent);
    } else if (session.status == TreatmentSessionStatus.completed) {
      bg = AppColors.success.withOpacity(0.12);
      fg = AppColors.success;
    } else if (session.isActiveVisit) {
      bg = colors.primary.withOpacity(0.12);
      fg = colors.primary;
    } else {
      bg = colors.onSurface.withOpacity(0.06);
      fg = colors.onSurface.withOpacity(0.5);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        session.badgeLabelKey.tr(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
