import 'package:dental_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingDotIndicator extends StatelessWidget {
  final int pageCount;
  final int currentIndex;

  const OnboardingDotIndicator({
    super.key,
    required this.pageCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 22 : 8,
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}