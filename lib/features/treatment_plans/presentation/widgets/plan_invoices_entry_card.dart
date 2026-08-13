import 'dart:ui' as ui;

import 'package:dental_app/features/treatment_plans/data/models/plan_invoice.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PlanInvoicesEntryCard extends StatelessWidget {
  final VoidCallback onTap;
  final PlanInvoiceSummary? summary;
  final int? invoiceCount;

  const PlanInvoicesEntryCard({
    super.key,
    required this.onTap,
    this.summary,
    this.invoiceCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withOpacity(isDark ? 0.30 : 0.10),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
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
                      'Invoices'.tr(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _subtitle(),
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurface.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isRtl ? Icons.chevron_left : Icons.chevron_right,
                color: colors.onSurface.withOpacity(0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle() {
    final count = invoiceCount;
    final bills = summary;
    if (count == null || bills == null) {
      return 'View bills for this plan'.tr();
    }
    if (count == 0) {
      return 'No invoices for this plan'.tr();
    }

    final countLabel = '{count} invoices'.tr(
      namedArgs: {'count': '$count'},
    );
    if (bills.hasRemaining) {
      return '$countLabel · ${'Remaining'.tr()} ${planMoney(bills.totalRemaining)}';
    }
    return '$countLabel · ${'Fully paid'.tr()}';
  }
}
