import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Empty successful list: Lottie + message, no retry.
class EmptyListState extends StatelessWidget {
  final String message;
  final double animationSize;

  const EmptyListState({
    super.key,
    required this.message,
    this.animationSize = 180,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/empty.json',
              width: animationSize,
              height: animationSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.inbox_outlined,
                size: animationSize * 0.45,
                color: colors.onSurface.withOpacity(0.35),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: colors.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
