import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/financial_and_billing/domain/financial_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PaymentCard extends StatelessWidget {
  final Map<String, dynamic> payment;
  /// 1-based order in the invoice payments list.
  final int paymentIndex;

  const PaymentCard({
    super.key,
    required this.payment,
    required this.paymentIndex,
  });

  String get _title {
    switch (paymentIndex) {
      case 1:
        return 'First Payment'.tr();
      case 2:
        return 'Second Payment'.tr();
      case 3:
        return 'Third Payment'.tr();
      case 4:
        return 'Fourth Payment'.tr();
      case 5:
        return 'Fifth Payment'.tr();
      default:
        return 'Payment {n}'.tr(namedArgs: {'n': '$paymentIndex'});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final amount = FinancialHelper.formatAmount(payment['amount']);
    final date =
        FinancialHelper.formatIssuedDate(payment['paidAt']?.toString());
    final method = (payment['method'] ?? '-').toString();
    final notes = (payment['notes'] ?? '').toString();

    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title,
                        style: TextStyle(
                          fontSize: 16,
                          color: colors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (notes.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          notes,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: colors.onSurface.withOpacity(0.45),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$amount S.P',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 2),
                Text(date, style: const TextStyle(color: AppColors.primary)),
              ],
            ),
            Divider(height: 25, color: Theme.of(context).colorScheme.shadow),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                method.tr(),
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
