import 'package:dental_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: selected ? AppColors.secondary: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onTap,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              textAlign: TextAlign.center,
              style: TextStyle(
                
                color: selected ? Colors.white : Colors.grey.shade700,
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }
}