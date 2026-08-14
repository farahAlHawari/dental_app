import 'package:flutter/material.dart';

/// كارد اختصار وحدة بشبكة 2x2 بالرئيسية. [isDanger] بتلوّنه بلون
/// تحذيري (لموعد الطوارئ) بدل الألوان العادية. العناصر بالنص أفقياً
/// وعمودياً، بنفس ألوان الكارد الأساسية (خلفية بيضا/سطح + تلوين الأيقونة).
class QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDanger;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
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
    final Color background = colors.surface; // نفس خلفية باقي الكرودات دايماً

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
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withOpacity(isDark ? 0.30 : 0.10),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: tint.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: tint, size: 26),
              ),
              const SizedBox(height: 14),
              Text(
                widget.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: widget.isDanger ? colors.error : colors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.3,
                  color: colors.onSurface.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
