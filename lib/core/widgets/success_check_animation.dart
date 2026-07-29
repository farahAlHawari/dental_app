import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// أنميشن "نجاح" (صح) تشتغل مرة وحدة وتوقف على فريم فيه الصح مرسومة
/// بالكامل - عكس تشغيلها بـ repeat:false العادي، يلي بيخليها تكمل لآخر
/// الملف وتوصل لجزء الـ fade-out المبني جوا أغلب ملفات Lottie الجاهزة
/// (المصممة أصلاً كحلقة/loop)، فتختفي وتخلي مكانها فاضي.
///
/// هون بنتحكم بالتشغيل يدوياً عبر AnimationController ومنوقفه عند
/// [stopAtFraction] من مدة الأنميشن الكاملة (بدل ما نخليه يوصل 100%),
/// فبيضل واقف عالصح وهي مرسومة بالكامل.
class SuccessCheckAnimation extends StatefulWidget {
  final String assetPath;
  final double size;

  /// أد إيش من الأنميشن (كنسبة من 0 لـ 1) بدنا نشغل قبل ما نوقف.
  /// جربي تنزليها أو تزوديها شوي شوي (مثلاً 0.5 أو 0.7) لحد ما توقف
  /// بالظبط لحظة ما تصير الصح مرسومة بالكامل عندك بملفك انت.
  final double stopAtFraction;

  const SuccessCheckAnimation({
    super.key,
    this.assetPath = 'assets/animations/correct.json',
    this.size = 120,
    this.stopAtFraction = 0.6,
  });

  @override
  State<SuccessCheckAnimation> createState() => _SuccessCheckAnimationState();
}

class _SuccessCheckAnimationState extends State<SuccessCheckAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Lottie.asset(
        widget.assetPath,
        controller: _controller,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            // هون التحكم الفعلي - بيوقف عند النسبة المطلوبة بدل ما
            // يكمل لآخر الملف.
            ..animateTo(widget.stopAtFraction);
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 42),
        ),
      ),
    );
  }
}
