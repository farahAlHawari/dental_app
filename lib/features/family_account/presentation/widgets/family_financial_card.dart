import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/family_account/presentation/pages/family_financial_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FamilyFinancialCard extends StatelessWidget {
  const FamilyFinancialCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    final iconBoxColor = isDark
        ? AppColors.primary.withOpacity(0.28)
        : Colors.white;

    final iconColor =
        isDark ? AppColors.summaryOnCardDark : colors.primary;

    final titleColor =
        isDark ? AppColors.summaryOnCardDark : colors.onSurface;

    final subtitleColor = isDark
        ? AppColors.summaryMutedDark
        : colors.onSurface.withOpacity(0.65);

    final chevronColor = isDark
        ? AppColors.summaryMutedDark
        : colors.onSurface.withOpacity(0.45);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FamilyFinancialPage(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark ? null : colors.primaryContainer,
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.summaryCardDarkStart,
                      AppColors.summaryCardDarkEnd,
                    ],
                  )
                : null,
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBoxColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.receipt_long, color: iconColor),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Family Financial Statement'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'View all invoices and payments'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: subtitleColor,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: chevronColor),
            ],
          ),
        ),
      ),
    );
  }
}
