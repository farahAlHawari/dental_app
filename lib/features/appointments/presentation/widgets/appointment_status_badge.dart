import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/models/appointment_status.dart';

/// شارة صغيرة (pill) بتعرض حالة الموعد بلونها المميز - نفس شكل الشارات
/// بالصورة المرجعية ("قيد الانتظار"، "مؤكد"...الخ).
class AppointmentStatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const AppointmentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    // النقطة الصغيرة منيح تضل بلونها الأصلي (زخرفة بس)، بس النص لازم
    // يقرا منيح فوق الخلفية الفاتحة تبعه - فبنغمّقه شوي هون بنفس تقنية
    // readableAccent يلي استخدمناها بأماكن تانية بالمشروع.
    final textColor = Color.alphaBlend(Colors.black.withOpacity(0.2), color);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.labelKey.tr(),
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
