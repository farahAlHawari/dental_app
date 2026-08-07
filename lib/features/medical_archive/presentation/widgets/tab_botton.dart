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
    final scheme = Theme.of(context).colorScheme;
    final unselectedColor = scheme.onSurface.withOpacity(0.55);
    // Keep app font (cr/ir from MaterialApp builder) — bare TextStyle drops it.
    final baseStyle = Theme.of(context).textTheme.labelLarge ??
        Theme.of(context).textTheme.bodyMedium ??
        const TextStyle();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: selected ? scheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: scheme.shadow.withOpacity(0.08),
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
              style: baseStyle.copyWith(
                color: selected ? scheme.onPrimary : unselectedColor,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
                height: 1.15,
              ),
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }
}
