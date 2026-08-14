import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/financial_and_billing/domain/financial_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Top financial totals card — tuned for light & dark contrast.
class FinancialSummaryCard extends StatelessWidget {
  final double totalBilled;
  final double totalPaid;
  final double totalRemaining;

  const FinancialSummaryCard({
    super.key,
    required this.totalBilled,
    required this.totalPaid,
    required this.totalRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? const [
              AppColors.summaryCardDarkStart,
              AppColors.summaryCardDarkEnd,
            ]
          : const [
              AppColors.summaryCardLightStart,
              AppColors.summaryCardLightEnd,
            ],
    );

    final onCard = isDark
        ? AppColors.summaryOnCardDark
        : AppColors.summaryOnCardLight;
    final muted = isDark
        ? AppColors.summaryMutedDark
        : AppColors.summaryMutedLight;
    final chipBg = isDark
        ? AppColors.primary.withOpacity(0.28)
        : Colors.white.withOpacity(0.18);
    final divider = onCard.withOpacity(isDark ? 0.12 : 0.18);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.45)
                  : AppColors.primary.withOpacity(0.22),
              blurRadius: isDark ? 18 : 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: gradient),
                ),
              ),
              Positioned(
                bottom: -14,
                right: -10,
                child: Opacity(
                  opacity: isDark ? 0.55 : 0.42,
                  child: Image.asset(
                    'assets/images/123.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
                child: Row(
                  children: [
                    _SummaryMetric(
                      icon: Icons.account_balance_wallet_rounded,
                      title: 'Total'.tr(),
                      amount: totalBilled,
                      onCard: onCard,
                      muted: muted,
                      chipBg: chipBg,
                    ),
                    _SummaryDivider(color: divider),
                    _SummaryMetric(
                      icon: Icons.verified_rounded,
                      title: 'Paid'.tr(),
                      amount: totalPaid,
                      onCard: onCard,
                      muted: muted,
                      chipBg: chipBg,
                    ),
                    _SummaryDivider(color: divider),
                    _SummaryMetric(
                      icon: Icons.timelapse_rounded,
                      title: 'Remaining'.tr(),
                      amount: totalRemaining,
                      onCard: onCard,
                      muted: muted,
                      chipBg: chipBg,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  final Color color;

  const _SummaryDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: color,
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final IconData icon;
  final String title;
  final double amount;
  final Color onCard;
  final Color muted;
  final Color chipBg;

  const _SummaryMetric({
    required this.icon,
    required this.title,
    required this.amount,
    required this.onCard,
    required this.muted,
    required this.chipBg,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: chipBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: onCard),
          ),
          const SizedBox(height: 10),
          Text(
            FinancialHelper.formatAmount(amount),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              height: 1.1,
              color: onCard,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
              color: muted,
            ),
          ),
        ],
      ),
    );
  }
}
