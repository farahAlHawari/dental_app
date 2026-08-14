import 'package:dental_app/features/appointments/data/models/appointment_status.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// كارد "موعدك القادم" أعلى الرئيسية - أول شي بيشوفه المريض لما يفوت
/// عالتطبيق، فمصمم كـ "hero card" بخلفية دِرَج (gradient) بلوني البرايمري/
/// السيكندري تبع التطبيق بدل خلفية باهتة، مع نصوص بيضا فوقها. بيانات
/// تجريبية حالياً (TODO: وصلها بأقرب موعد فعلي للمريض لما يجهز الـ backend).
class UpcomingAppointmentCard extends StatelessWidget {
  final String treatmentName;

  /// تاريخ الموعد الحقيقي (مش نص جاهز) - محتاجينه لحساب "باقي كم يوم".
  final DateTime appointmentDate;
  final String timeLabel; // مثال: '02:00 PM'
  final AppointmentStatus status;

  /// بينفذ لما يضغط المريض على أيقونة مسح QR (فعالة بس لما تكون
  /// الحالة confirmed) - المفروض ياخده لشاشة المسح [QrCheckinScannerPage].
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
    final isConfirmed = status == AppointmentStatus.confirmed;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.secondary],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // لمسة زخرفية بسيطة بس (دائرتين شفافتين بزاوية الكارد) حتى
            // ما يضل الكارد فارغ/مسطّح، بحركة بطيئة وناعمة حتى ما تحس
            // الكارد "ثابت وميت" بلا ما يصير فيه ازدحام بصري.
            // const Positioned(
            //   top: -34,
            //   right: -28,
            //   child: _FloatingBlob(
            //     size: 130,
            //     opacity: 0.06,
            //     duration: Duration(seconds: 7),
            //     range: Offset(10, 12),
            //   ),
            // ),
            // const Positioned(
            //   bottom: -46,
            //   left: -24,
            //   child: _FloatingBlob(
            //     size: 110,
            //     opacity: 0.05,
            //     duration: Duration(seconds: 9),
            //     range: Offset(12, 8),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.event_outlined,
                              size: 15,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Upcoming Appointment'.tr(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _daysLeftLabel,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // صف الستاتوس + اسم الموعد عالطرف الأول، وأيقونة مسح QR
                  // عالطرف الثاني - جنب هالسطرين بالتحديد.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _StatusPill(status: status),
                            const SizedBox(height: 10),
                            Text(
                              treatmentName,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _QrCheckInIcon(
                        isConfirmed: isConfirmed,
                        onTap: isConfirmed ? (onScanQr ?? () {}) : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 15,
                          color: Colors.white.withOpacity(0.85),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$_formattedDate | $timeLabel',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isConfirmed) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Awaiting clinic confirmation'.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// شارة حالة الموعد بنسخة "فوق خلفية ملوّنة" - نفس فكرة
/// [AppointmentStatusBadge] المستخدمة بباقي الشاشات (نقطة بلون الحالة +
/// نص)، بس بخلفية بيضا شفافة ونص أبيض دايماً حتى تضل واضحة فوق الدِرَج،
/// بدل ما تعتمد على لون الحالة نفسه كنص (يلي ممكن يختفي فوق خلفية ملوّنة).
class _StatusPill extends StatelessWidget {
  final AppointmentStatus status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.labelKey.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// أيقونة مسح QR - أنيميشن لوتي شغال باستمرار طول الوقت (مش بس لما يكون
/// الموعد مؤكد)، بس بيضل فاتح اللون وغير قابل للضغط لحد ما تصير الحالة
/// "مؤكد" (باهتة شوي وممنوع الضغط عليها قبلها). خلفية بيضا شبه صافية (مش
/// شفافة بس) حتى ألوان أنيميشن الـ QR (يلي أساساً بعائلة البرايمري) تبين
/// وتتركز فوقها بدل ما تندمج مع خلفية الكارد الملونة.
class _QrCheckInIcon extends StatelessWidget {
  final bool isConfirmed;
  final VoidCallback? onTap;

  const _QrCheckInIcon({required this.isConfirmed, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: isConfirmed ? 1 : 0.5,
        child: Container(
          width: 64,
          height: 64,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color.lerp(Colors.white, colors.primary, 0.22),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Lottie.asset(
            'assets/animations/QR.json',
            repeat: true,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.qr_code_scanner_rounded,
              color: colors.primary,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

/// دائرة زخرفية بتتحرك ببطء وبشكل عضوي (ذهاب وإياب ناعم) - مستخدمة
/// كخلفية بسيطة بزوايا الكارد حتى تحس الكارد "حي" بلا ما تلفت الانتباه
/// عن المحتوى الأساسي.
class _FloatingBlob extends StatefulWidget {
  final double size;
  final double opacity;
  final Duration duration;
  final Offset range;

  const _FloatingBlob({
    required this.size,
    required this.opacity,
    required this.duration,
    required this.range,
  });

  @override
  State<_FloatingBlob> createState() => _FloatingBlobState();
}

class _FloatingBlobState extends State<_FloatingBlob>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value) * 2 - 1;
        return Transform.translate(
          offset: Offset(widget.range.dx * t, widget.range.dy * t),
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(widget.opacity),
        ),
      ),
    );
  }
}
