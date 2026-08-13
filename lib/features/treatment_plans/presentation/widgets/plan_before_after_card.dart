import 'package:dental_app/features/treatment_plans/presentation/widgets/plan_network_before_after.dart';
import 'package:flutter/material.dart';

class PlanBeforeAfterCard extends StatelessWidget {
  final String title;
  final String date;
  final String beforeImageUrl;
  final String afterImageUrl;

  const PlanBeforeAfterCard({
    super.key,
    required this.title,
    required this.date,
    required this.beforeImageUrl,
    required this.afterImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
          ],
          AspectRatio(
            aspectRatio: 16 / 10,
            child: PlanNetworkBeforeAfter(
              beforeImageUrl: beforeImageUrl,
              afterImageUrl: afterImageUrl,
            ),
          ),
          if (date.isNotEmpty && date != '-') ...[
            const SizedBox(height: 10),
            Text(
              date,
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
