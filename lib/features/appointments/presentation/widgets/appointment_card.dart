import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/appointment_status.dart';
import '../utils/appointment_date_format.dart';
import 'appointment_status_badge.dart';

/// كرت عرض موعد واحد - يعرض بيانات الموعد وشارة حالته، وأزرار الإلغاء/التعديل
/// بس لما تسمح حالة الموعد فيها (`AppointmentStatus.allowsCancelOrReschedule`)،
/// بالإضافة لزر "مسح QR لتأكيد الوصول" لما يكون الموعد بحالة "مؤكد".
///
/// TODO: فعالية زري الإلغاء/التعديل حالياً ثابتة (تظهر دايماً لما تسمح
/// الحالة) - لما يوصل الـ backend لازم تُبنى فعلياً على flags جاهزة من
/// استجابة الـ API (canCancel / canReschedule) يلي بتاخد بعين الاعتبار مهلة
/// الإلغاء القابلة للتخصيص لكل عيادة.
class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;
  final VoidCallback? onScanQr;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onReschedule,
    this.onScanQr,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final status = appointment.status;

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
                child: Text(
                  appointment.visitTypeLabel,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AppointmentStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: colors.primary,
                size: 16,
              ),
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
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.error,
                      // side: BorderSide(color: colors.error.withOpacity(0.4)),
                      // backgroundColor: colors.error.withOpacity(0.06),
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
                    onPressed: onReschedule,
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

          // زر مسح QR - يظهر بس لما الموعد "مؤكد" (جاهز لتأكيد الوصول
          // فعلياً بالعيادة)، جنب أزرار الإلغاء/التعديل فوق (مش بدالها).
          if (status == AppointmentStatus.confirmed) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onScanQr,
                icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                label: Text(
                  'Scan QR to Check In'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primary,
                  backgroundColor: colors.primary.withOpacity(0.06),
                  side: BorderSide(color: colors.primary.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
