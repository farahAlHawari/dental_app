import 'package:flutter/material.dart';

class VisitTypeCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const VisitTypeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<VisitTypeCard> createState() => _VisitTypeCardState();
}

class _VisitTypeCardState extends State<VisitTypeCard> {
  double _scale = 1;

  void _setPressed(bool pressed) => setState(() => _scale = pressed ? 0.97 : 1);

  Color get _readableAccent =>
      Color.alphaBlend(Colors.black.withOpacity(0.22), widget.accentColor);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withOpacity(isDark ? 0.35 : 0.12),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 90,
                decoration: BoxDecoration(
                  color: widget.accentColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: colors.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.actionText,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _readableAccent,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 13,
                          color: _readableAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.accentColor.withOpacity(0.22),
                      widget.accentColor.withOpacity(0.06),
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(widget.icon, color: widget.accentColor, size: 26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
