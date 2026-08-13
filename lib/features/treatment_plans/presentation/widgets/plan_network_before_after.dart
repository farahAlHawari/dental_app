import 'package:before_after/before_after.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Comparison slider for plan before/after photos from the network.
/// Kept in treatment_plans so the asset-only gallery slider stays untouched.
class PlanNetworkBeforeAfter extends StatefulWidget {
  final String beforeImageUrl;
  final String afterImageUrl;
  final double borderRadius;
  final double initialValue;

  const PlanNetworkBeforeAfter({
    super.key,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    this.borderRadius = 16,
    this.initialValue = 0.5,
  });

  @override
  State<PlanNetworkBeforeAfter> createState() => _PlanNetworkBeforeAfterState();
}

class _PlanNetworkBeforeAfterState extends State<PlanNetworkBeforeAfter> {
  late double _sliderValue = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        children: [
          Positioned.fill(
            child: BeforeAfter(
              value: _sliderValue,
              onValueChanged: (value) => setState(() => _sliderValue = value),
              thumbColor: colors.primary,
              trackColor: colors.primary,
              before: SizedBox.expand(
                child: _NetworkPhoto(url: widget.beforeImageUrl),
              ),
              after: SizedBox.expand(
                child: _NetworkPhoto(url: widget.afterImageUrl),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: _ImageTag(text: 'Before'.tr(), color: colors.primary),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: _ImageTag(text: 'After'.tr(), color: colors.primary),
          ),
        ],
      ),
    );
  }
}

class _NetworkPhoto extends StatelessWidget {
  final String url;

  const _NetworkPhoto({required this.url});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (url.isEmpty) {
      return ColoredBox(
        color: colors.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: colors.onSurface.withOpacity(0.4),
        ),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => ColoredBox(
        color: colors.surfaceContainerHighest,
        child: Icon(
          Icons.broken_image_outlined,
          color: colors.onSurface.withOpacity(0.4),
        ),
      ),
    );
  }
}

class _ImageTag extends StatelessWidget {
  final String text;
  final Color color;

  const _ImageTag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
