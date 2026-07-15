import 'package:flutter/material.dart';
import 'package:dental_app/core/theme/app_colors.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedlangage;
  final Function(String) onChanged;

  const LanguageSelector({
    super.key,
    required this.selectedlangage,
    required this.onChanged,
  });

  Widget _languageCard(
    String title,
    String subtitle,
    AssetImage image,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.15)
              : const Color.fromARGB(255, 218, 235, 242),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Image.asset(image.assetName, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(title),
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
          child: _languageCard(
            "العربية",
            "Arabic",
           const AssetImage("assets/images/1.png"),
            selectedlangage == "Arabic",
            () => onChanged("Arabic"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _languageCard(
            "English",
            "الإنجليزية",
            const AssetImage("assets/images/1.png"),
            selectedlangage == "English",
            () => onChanged("English"),
          ),
        ),
      ],
    );
  }
}