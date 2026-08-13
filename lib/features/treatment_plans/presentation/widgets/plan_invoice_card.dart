import 'package:dental_app/features/medical_archive/domain/medical_archive_helper.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_invoice.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/plan_invoice_status_badge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PlanInvoiceCard extends StatelessWidget {
  final PlanInvoice invoice;
  final VoidCallback? onTap;

  const PlanInvoiceCard({
    super.key,
    required this.invoice,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final remaining = double.tryParse(invoice.remainingAmount) ?? 0;
    final date = MedicalArchiveHelper.formatDate(
      invoice.issuedAt?.toIso8601String(),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Invoice #{number}'.tr(
                      namedArgs: {'number': invoice.invoiceNumber},
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                PlanInvoiceStatusBadge(status: invoice.status),
              ],
            ),
            const SizedBox(height: 10),
            if (invoice.payments.isNotEmpty)
              Text(
                '{count} payments'.tr(
                  namedArgs: {'count': '${invoice.payments.length}'},
                ),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
            if (invoice.payments.isNotEmpty) const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 6),
                Text(
                  date,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                _AmountBox(
                  label: 'Total'.tr(),
                  value: invoice.totalAmount,
                ),
                _AmountBox(
                  label: 'Paid'.tr(),
                  value: invoice.paidAmount,
                  background: const Color(0xFF2ECC71).withOpacity(0.12),
                  valueColor: const Color(0xFF2ECC71),
                ),
                _AmountBox(
                  label: remaining > 0 ? 'Remaining'.tr() : 'Due'.tr(),
                  value: invoice.remainingAmount,
                  background: remaining > 0
                      ? const Color(0xFFE74C3C).withOpacity(0.10)
                      : null,
                  valueColor: remaining > 0 ? const Color(0xFFE74C3C) : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountBox extends StatelessWidget {
  final String label;
  final String value;
  final Color? background;
  final Color? valueColor;

  const _AmountBox({
    required this.label,
    required this.value,
    this.background,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: background ?? colors.onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              planMoney(value),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: valueColor ?? colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
