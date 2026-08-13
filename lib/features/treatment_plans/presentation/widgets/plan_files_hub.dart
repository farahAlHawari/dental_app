import 'package:dental_app/features/home/presentation/widgets/quick_action_card.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session_files.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PlanFilesHub extends StatelessWidget {
  final TreatmentPlan plan;
  final ValueChanged<PlanFileKind> onOpen;

  const PlanFilesHub({
    super.key,
    required this.plan,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan files'.tr(),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.05,
          children: [
            QuickActionCard(
              icon: Icons.description_outlined,
              label: 'Reports'.tr(),
              subtitle: _countLabel(plan.reportCount),
              onTap: () => onOpen(PlanFileKind.reports),
            ),
            QuickActionCard(
              icon: Icons.medication_outlined,
              label: 'Prescriptions'.tr(),
              subtitle: _countLabel(plan.prescriptionCount),
              onTap: () => onOpen(PlanFileKind.prescriptions),
            ),
            QuickActionCard(
              icon: Icons.photo_filter_outlined,
              label: 'Radiographs'.tr(),
              subtitle: _countLabel(plan.radiographCount),
              onTap: () => onOpen(PlanFileKind.radiographs),
            ),
            QuickActionCard(
              icon: Icons.compare_outlined,
              label: 'Before and After'.tr(),
              subtitle: _countLabel(plan.beforeAfterCount),
              onTap: () => onOpen(PlanFileKind.beforeAfter),
            ),
          ],
        ),
      ],
    );
  }

  String _countLabel(int count) => '{count} files'.tr(
        namedArgs: {'count': '$count'},
      );
}
