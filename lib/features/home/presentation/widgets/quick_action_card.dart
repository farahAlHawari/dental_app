import 'package:flutter/material.dart';

/// كارد اختصار وحدة بشبكة 2x2 بالرئيسية. [isDanger] بتلوّنه بلون
/// تحذيري (لموعد الطوارئ) بدل الألوان العادية.
class QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDanger;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Color tint = widget.isDanger ? colors.error : colors.primary;
    final Color background = widget.isDanger
        ? colors.error.withOpacity(isDark ? 0.16 : 0.08)
        : colors.surface;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
            boxShadow: widget.isDanger
                ? []
                : [
                    BoxShadow(
                      color: colors.shadow.withOpacity(isDark ? 0.30 : 0.10),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: tint.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: tint, size: 21),
              ),
              const SizedBox(height: 10),
              Text(
  widget.label,
  textAlign: TextAlign.center,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: widget.isDanger ? colors.error : colors.onSurface,
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}
