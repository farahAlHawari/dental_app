import 'package:dental_app/features/treatment_plans/data/models/plan_invoice.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PlanInvoiceSummaryCard extends StatelessWidget {
  final PlanInvoiceSummary summary;

  const PlanInvoiceSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: colors.primary.withAlpha(200),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                _SummaryItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Total'.tr(),
                  value: planMoney(summary.totalBilled),
                ),
                _divider(),
                _SummaryItem(
                  icon: Icons.check_circle_outline,
                  title: 'Paid'.tr(),
                  value: planMoney(summary.totalPaid),
                ),
                _divider(),
                _SummaryItem(
                  icon: Icons.hourglass_empty_rounded,
                  title: 'Remaining'.tr(),
                  value: planMoney(summary.totalRemaining),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -10,
            right: -8,
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/images/123.png',
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.25),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: colors.onSecondary),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
