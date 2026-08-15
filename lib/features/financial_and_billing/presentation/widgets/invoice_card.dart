import 'package:dental_app/core/widgets/patient_avatar.dart';
import 'package:dental_app/features/financial_and_billing/domain/financial_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  final String invoiceNumber;
  final String treatmentName;
  final String date;
  final double total;
  final double paid;
  final double remaining;
  final String status;
  final String? sessionInfo;
  final String? patientName;
  final String? patientImageUrl;
  final VoidCallback? onTap;

  const InvoiceCard({
    super.key,
    required this.invoiceNumber,
    required this.treatmentName,
    required this.date,
    required this.total,
    required this.paid,
    required this.remaining,
    required this.status,
    this.sessionInfo,
    this.patientName,
    this.patientImageUrl,
    this.onTap,
  });

  Widget _amountBox(
    BuildContext context, {
    required String label,
    required String value,
    Color? bg,
    Color? valueColor,
  }) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: bg ?? onSurface.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: onSurface.withOpacity(0.55),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$value S.P',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: valueColor ?? onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final statusColor = FinancialHelper.statusColor(context, status);
    final paidColor =
        FinancialHelper.statusColor(context, FinancialHelper.statusPaid);
    final unpaidColor =
        FinancialHelper.statusColor(context, FinancialHelper.statusUnpaid);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${'Invoice'.tr()} #$invoiceNumber',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurface.withOpacity(0.55),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: FinancialHelper.statusSoftBg(context, status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        FinancialHelper.statusLabel(status),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (patientName != null && patientName!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  PatientAvatar(
                    imageUrl: patientImageUrl,
                    radius: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      patientName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Text(
              treatmentName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            if (sessionInfo != null && sessionInfo!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                sessionInfo!,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.onSurface.withOpacity(0.55),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: colors.onSurface.withOpacity(0.45),
                ),
                const SizedBox(width: 6),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurface.withOpacity(0.55),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                _amountBox(
                  context,
                  label: 'TOTAL'.tr(),
                  value: FinancialHelper.formatAmount(total),
                ),
                _amountBox(
                  context,
                  label: 'PAID'.tr(),
                  value: FinancialHelper.formatAmount(paid),
                  bg: paidColor.withOpacity(0.12),
                  valueColor: paidColor,
                ),
                if (remaining > 0)
                  _amountBox(
                    context,
                    label: 'REMAINING'.tr(),
                    value: FinancialHelper.formatAmount(remaining),
                    bg: unpaidColor.withOpacity(0.10),
                    valueColor: unpaidColor,
                  )
                else
                  _amountBox(
                    context,
                    label: 'DUE'.tr(),
                    value: '0',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
