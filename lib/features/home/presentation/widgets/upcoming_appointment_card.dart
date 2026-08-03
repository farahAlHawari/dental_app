import 'package:dental_app/features/appointments/data/models/appointment_status.dart';
import 'package:dental_app/features/appointments/presentation/widgets/appointment_status_badge.dart';
import 'package:dental_app/features/home/presentation/widgets/checkin_scan_prompt.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// كارد "موعدك القادم" أعلى الرئيسية. بيانات تجريبية حالياً (TODO:
/// وصلها بأقرب موعد فعلي للمريض لما يجهز الـ backend).
class UpcomingAppointmentCard extends StatelessWidget {
  final String treatmentName;

  /// تاريخ الموعد الحقيقي (مش نص جاهز) - محتاجينه لحساب "باقي كم يوم".
  final DateTime appointmentDate;
  final String timeLabel; // مثال: '02:00 PM'
  final AppointmentStatus status;

  /// بينفذ لما يضغط المريض على أيقونة مسح QR (تظهر بس لما تكون الحالة
  /// confirmed) - المفروض ياخده لشاشة المسح [QrCheckinScannerPage].
  final VoidCallback? onScanQr;

  const UpcomingAppointmentCard({
    super.key,
    required this.treatmentName,
    required this.appointmentDate,
    required this.timeLabel,
    required this.status,
    this.onScanQr,
  });

  static const _weekdayKeys = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _monthKeys = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get _formattedDate {
    final weekday = _weekdayKeys[appointmentDate.weekday - 1].tr();
    final month = _monthKeys[appointmentDate.month - 1].tr();
    return '$weekday, $month ${appointmentDate.day}';
  }

  /// "باقي كم يوم" - بيقارن تاريخ الموعد فقط (بلا وقت) مع تاريخ اليوم.
  String get _daysLeftLabel {
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    final appointmentDateOnly = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
    );
    final daysLeft = appointmentDateOnly.difference(todayDateOnly).inDays;

    if (daysLeft <= 0) return 'Today'.tr();
    if (daysLeft == 1) return 'Tomorrow'.tr();
    return 'In {days} days'.tr(namedArgs: {'days': '$daysLeft'});
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        // خفّفت الأوباسيتي أكتر (كانت 0.05).
        color: colors.secondary.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.secondary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: 15,
                    color: colors.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Upcoming Appointment'.tr(),
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _daysLeftLabel,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              AppointmentStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colors.secondary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.medical_services_rounded,
                  color: colors.secondary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  treatmentName,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
              ),
              // مكان أيقونة المسح - جنب معلومات الموعد مباشرة، بالمساحة
              // الفاضية على يمين الكارد (بس لما تكون الحالة مؤكدة).
              if (status == AppointmentStatus.confirmed) ...[
                const SizedBox(width: 10),
                CheckInScanPrompt(onTap: onScanQr ?? () {}),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date & Time'.tr(),
                      style: TextStyle(
                        fontSize: 11.5,
                        color: colors.onSurface.withOpacity(0.55),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$_formattedDate | $timeLabel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (status != AppointmentStatus.confirmed) ...[
            const SizedBox(height: 14),
            // TODO: لسا ما قررنا شكلها النهائي لباقي الحالات - هلق حاطة
            // تذكير بسيط بانتظار تأكيد العيادة كـ default.
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: colors.onSurface.withOpacity(0.45),
                ),
                const SizedBox(width: 8),
                Text(
                  'Awaiting clinic confirmation'.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurface.withOpacity(0.5),
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
