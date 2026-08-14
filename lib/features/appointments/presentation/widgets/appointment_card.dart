import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/appointment_status.dart';
import '../utils/appointment_date_format.dart';
import 'appointment_status_badge.dart';
import '../../../home/presentation/widgets/checkin_scan_prompt.dart';

/// كرت عرض موعد واحد - يعرض بيانات الموعد وشارة حالته، وأزرار الإلغاء/التعديل
/// بس لما تسمح حالة الموعد فيها (`AppointmentStatus.allowsCancelOrReschedule`)،
/// بالإضافة لزر "مسح QR لتأكيد الوصول" لما يكون الموعد بحالة "مؤكد".
class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;
  final VoidCallback? onScanQr;
  final bool actionsEnabled;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onReschedule,
    this.onScanQr,
    this.actionsEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final status = appointment.status;
    final isFollowUp =
        appointment.bookingType == AppointmentBookingType.followUp;
    final sessionTitle = isFollowUp
        ? appointment.localizedSessionTitle(context.locale.languageCode)
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(isDark ? 0.30 : 0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.visitTypeLabel,
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (sessionTitle != null && sessionTitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        sessionTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.onSurface.withOpacity(0.65),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (status == AppointmentStatus.confirmed &&
                  onScanQr != null) ...[
                CheckInScanPrompt(onTap: onScanQr!, size: 32),
                const SizedBox(width: 8),
              ],
              AppointmentStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              // بادج ساعة بأنيميشن نبض (توهج) خفيف مبني بألوان الثيم
              // مباشرة (بلا أي ملف لوتي جاهز) - هيك بيتأقلم تلقائياً مع
              // الثيم الفاتح والغامق بلا أي خلفية غريبة زائدة.
              const _PulsingClockBadge(),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${formatAppointmentDate(appointment.scheduledAt)} | ${formatAppointmentTime(appointment.scheduledAt)}',
                  style: TextStyle(
                    color: colors.onSurface.withOpacity(0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          if (status.allowsCancelOrReschedule) ...[
            const SizedBox(height: 14),
            Divider(height: 1, color: colors.onSurface.withOpacity(0.08)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: actionsEnabled ? onCancel : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.error,
                      side: BorderSide.none,
                      backgroundColor: colors.error.withOpacity(0.14),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Cancel Appointment'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: actionsEnabled ? onReschedule : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.onSurface,
                      side: BorderSide(color: colors.outline.withOpacity(0.35)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Reschedule Appointment'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// بادج ساعة بأنيميشن نبض (توهج) بسيط - بديل عن أنيميشن لوتي جاهز حتى
/// نتجنب أي خلفية مرسومة جوا الملف نفسه بتطلع غريبة بالثيم الغامق. نفس
/// تقنية التوهج المستخدمة بكارد المساعد الذكي وكارد النصيحة اليومية.
class _PulsingClockBadge extends StatefulWidget {
  const _PulsingClockBadge();

  @override
  State<_PulsingClockBadge> createState() => _PulsingClockBadgeState();
}

class _PulsingClockBadgeState extends State<_PulsingClockBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glow = _controller.value;
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.primary.withOpacity(0.12 + glow * 0.10),
          ),
          child: child,
        );
      },
      child: Icon(Icons.schedule_rounded, color: colors.primary, size: 14),
    );
  }
}
