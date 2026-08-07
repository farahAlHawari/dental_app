import 'package:dental_app/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  final String selectedGender;
  final Function(String) onChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  Widget _genderCard(
    BuildContext context,
    String title,
    IconData icon,
    bool selected,
    VoidCallback onTap,
  ) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primaryContainer
    : Theme.of(context).brightness == Brightness.light
        ? AppColors.CardLight
        : AppColors.CardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? colors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: colors.onSurface,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _genderCard(
            context,
            "Male".tr(),
            Icons.male,
            selectedGender == "Male",
            () => onChanged("Male"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _genderCard(
            context,
            "Female".tr(),
            Icons.female,
            selectedGender == "Female",
            () => onChanged("Female"),
          ),
        ),
      ],
    );
  }
}