import 'package:flutter/material.dart';

/// أيقونة إشعارات بحركة "رنّة" واضحة (تهزّة سريعة كم مرة) بتتكرر كل كم
/// ثانية، بدل التمايل الخفيف يلي كان صعب ملاحظته.
class AnimatedNotificationIcon extends StatefulWidget {
  final VoidCallback onTap;
  /// Unread count for the badge. `0` hides the badge.
  final int unreadCount;

  const AnimatedNotificationIcon({
    super.key,
    required this.onTap,
    this.unreadCount = 0,
  });

  @override
  State<AnimatedNotificationIcon> createState() =>
      _AnimatedNotificationIconState();
}

class _AnimatedNotificationIconState extends State<AnimatedNotificationIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _swing;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    // 2.6 ثانية كل دورة: أول ~0.8 ثانية فيها الرنّة الفعلية (كم تهزّة
    // متتالية)، والباقي وقفة قبل ما تتكرر - هيك واضحة بس مش مزعجة.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();

    _swing = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.35), weight: 8),
      TweenSequenceItem(tween: Tween(begin: 0.35, end: -0.32), weight: 8),
      TweenSequenceItem(tween: Tween(begin: -0.32, end: 0.24), weight: 8),
      TweenSequenceItem(tween: Tween(begin: 0.24, end: -0.14), weight: 8),
      TweenSequenceItem(tween: Tween(begin: -0.14, end: 0.0), weight: 8),
      // وقفة (بلا حركة) لباقي مدة الدورة لحد ما تعيد الكرّة.
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 60),
    ]).animate(_controller);

    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 60),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: widget.onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.rotate(
              angle: _swing.value,
              child: Transform.scale(scale: _scale.value, child: child),
            ),
            child: Icon(Icons.notifications_outlined, color: colors.onSurface),
          ),
          if (widget.unreadCount > 0)
            Positioned(
              top: -4,
              right: -6,
              child: Container(
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: colors.error,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colors.surfaceContainerHighest,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.unreadCount > 99 ? '99+' : '${widget.unreadCount}',
                  style: TextStyle(
                    color: colors.onError,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
