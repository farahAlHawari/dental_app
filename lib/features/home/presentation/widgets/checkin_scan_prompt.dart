import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// أيقونة مسح QR بس (بلا نص) بنبضة خفيفة مستمرة تلفت الانتباه - بتتحط
/// جنب معلومات الموعد مباشرة بدل ما تاخد سطر كامل لحالها. بتظهر بس لما
/// يكون الموعد confirmed. بالضغط عليها المفروض تاخد المريض لشاشة مسح
/// الـQR (لسا ما انبنت - TODO تحت).
class CheckInScanPrompt extends StatefulWidget {
  final VoidCallback onTap;
  final double size;

  const CheckInScanPrompt({super.key, required this.onTap, this.size = 40});

  @override
  State<CheckInScanPrompt> createState() => _CheckInScanPromptState();
}

class _CheckInScanPromptState extends State<CheckInScanPrompt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Tooltip(
      message: 'Scan QR to confirm your arrival'.tr(),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(widget.size / 2),
        child: ScaleTransition(
          scale: _pulse,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.qr_code_scanner_rounded,
              size: widget.size * 0.5,
              color: colors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
