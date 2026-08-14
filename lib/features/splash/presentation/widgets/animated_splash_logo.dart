import 'package:flutter/material.dart';

/// Brand mark — [logo1.png], optionally [phrase.png] (primary tint) below.
///
/// Splash (first launch): fade + scale once, with phrase.
/// Bootstrap: looping pulse on the logo only (no phrase).
class AnimatedSplashLogo extends StatefulWidget {
  const AnimatedSplashLogo({
    super.key,
    this.logoWidth = 280,
    this.showPhrase = true,
    this.loop = false,
  });

  final double logoWidth;
  final bool showPhrase;
  final bool loop;

  static const String logoAsset = 'assets/images/logo1.png';
  static const String phraseAsset = 'assets/images/phrase.png';

  @override
  State<AnimatedSplashLogo> createState() => _AnimatedSplashLogoState();
}

class _AnimatedSplashLogoState extends State<AnimatedSplashLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _phraseOpacity;
  late final Animation<double> _phraseSlide;

  @override
  void initState() {
    super.initState();

    if (widget.loop) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1600),
      );
      final pulse = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      );
      _logoScale = Tween<double>(begin: 0.94, end: 1.04).animate(pulse);
      _logoOpacity = const AlwaysStoppedAnimation(1.0);
      _phraseOpacity = const AlwaysStoppedAnimation(0.0);
      _phraseSlide = const AlwaysStoppedAnimation(0.0);
      _controller.repeat(reverse: true);
      return;
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    final logoCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.62, curve: Curves.easeOutCubic),
    );
    _logoScale = Tween<double>(begin: 0.88, end: 1.0).animate(logoCurve);
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(logoCurve);

    final phraseCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.38, 1.0, curve: Curves.easeOutCubic),
    );
    _phraseOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(phraseCurve);
    _phraseSlide = Tween<double>(begin: 14, end: 0).animate(phraseCurve);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final phraseWidth = widget.logoWidth * 0.82;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: _logoOpacity.value,
              child: Transform.scale(
                scale: _logoScale.value,
                child: Image.asset(
                  AnimatedSplashLogo.logoAsset,
                  width: widget.logoWidth,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            if (widget.showPhrase) ...[
              const SizedBox(height: 2),
              Opacity(
                opacity: _phraseOpacity.value,
                child: Transform.translate(
                  offset: Offset(0, _phraseSlide.value - 6),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                    child: Image.asset(
                      AnimatedSplashLogo.phraseAsset,
                      width: phraseWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
