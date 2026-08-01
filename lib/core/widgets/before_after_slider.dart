import 'package:before_after/before_after.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// سلايدر مقارنة "قبل/بعد" قابل لإعادة الاستخدام - مستخدم بصفحة "رحلتي
/// العلاجية" وبالمعرض التسويقي معاً، حتى يضل شكله موحّد بكل الأماكن.
///
/// ما بيحدد نسبة أبعاد (aspect ratio) بنفسه، خليها مسؤولية الشاشة يلي
/// عم تستخدمه (كل شاشة إلها النسبة يلي بتناسبها).
class BeforeAfterSlider extends StatefulWidget {
  final String beforeImagePath;
  final String afterImagePath;
  final double borderRadius;
  final double initialValue;
  final String beforeLabel;
  final String afterLabel;

  const BeforeAfterSlider({
    super.key,
    required this.beforeImagePath,
    required this.afterImagePath,
    this.borderRadius = 16,
    this.initialValue = 0.5,
    this.beforeLabel = 'Before',
    this.afterLabel = 'After',
  });

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
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
                child: Image.asset(widget.beforeImagePath, fit: BoxFit.cover),
              ),
              after: SizedBox.expand(
                child: Image.asset(widget.afterImagePath, fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: _ImageTag(text: widget.beforeLabel.tr(), color: colors.primary),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: _ImageTag(text: widget.afterLabel.tr(), color: colors.primary),
          ),
        ],
      ),
    );
  }
}

/// Badge صغير لكتابة Before / After فوق الصورة.
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
