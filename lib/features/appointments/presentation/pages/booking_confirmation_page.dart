import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/appointments/presentation/utils/appointment_date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// آخر شاشة بمسار الحجز - ملخص نوع الزيارة والتاريخ والوقت، وزر تأكيد
/// نهائي. ما إلها رقم خطوة (زي step 1/2/3) لأنها شاشة المراجعة الأخيرة
/// مش خطوة إضافية بنفس تسلسل الحجز.
class BookingConfirmationPage extends StatelessWidget {
  // static const List<String> _weekdayFullKeys = [
  //   'Monday',
  //   'Tuesday',
  //   'Wednesday',
  //   'Thursday',
  //   'Friday',
  //   'Saturday',
  //   'Sunday',
  // ];
  // static const List<String> _monthKeys = [
  //   'January',
  //   'February',
  //   'March',
  //   'April',
  //   'May',
  //   'June',
  //   'July',
  //   'August',
  //   'September',
  //   'October',
  //   'November',
  //   'December',
  // ];

  final String visitTypeLabel;
  final DateTime date;
  final String time;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const BookingConfirmationPage({
    super.key,
    required this.visitTypeLabel,
    required this.date,
    required this.time,
    required this.onConfirm,
    this.onCancel,
  });

  // String get _formattedDate {
  //   final weekday = _weekdayFullKeys[date.weekday - 1].tr();
  //   final month = _monthKeys[date.month - 1].tr();
  //   return '$weekday ${date.day} $month ${date.year}';
  // }

  String get _formattedDate => formatAppointmentDate(date);

  Widget _summaryRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: colors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  color: colors.onSurface.withOpacity(0.55),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final readableAccent = Color.alphaBlend(
      Colors.black.withOpacity(0.25),
      AppColors.accent,
    );
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: colors.surfaceContainerHighest,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_forward, color: colors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Book New Appointment'.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/background3.png',
                fit: BoxFit.cover,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FadeSlideIn(
                            child: Center(
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: 1),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOutBack,
                                builder: (context, value, child) =>
                                    Transform.scale(scale: value, child: child),
                                child: LottieBuilder.asset(
                                  "assets/animations/correct.json",
                                  width: 95,
                                  height: 95,
                                  repeat: true,

                                  // أنميشن "نجاح" منطقياً تشتغل مرة وحدة وتوقف
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 84,
                                        height: 84,
                                        decoration: BoxDecoration(
                                          color: colors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 42,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 60),
                            child: Text(
                              'Confirm Booking Request'.tr(),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colors.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 100),
                            child: Text(
                              'Please review your appointment details before final confirmation.'
                                  .tr(),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurface.withOpacity(0.6),
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          FadeSlideIn(
                            delay: const Duration(milliseconds: 160),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.shadow.withOpacity(
                                      isDark ? 0.30 : 0.10,
                                    ),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _summaryRow(
                                    context,
                                    icon: Icons.medical_information_outlined,
                                    label: 'Visit Type'.tr(),
                                    value: visitTypeLabel,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    child: Divider(height: 1),
                                  ),
                                  _summaryRow(
                                    context,
                                    icon: Icons.calendar_today_outlined,
                                    label: 'Date'.tr(),
                                    value: _formattedDate,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    child: Divider(height: 1),
                                  ),
                                  _summaryRow(
                                    context,
                                    icon: Icons.access_time_rounded,
                                    label: 'Time'.tr(),
                                    value: formatMockTimeLabel(time),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          FadeSlideIn(
                            delay: const Duration(milliseconds: 220),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: colors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: colors.primary),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: colors.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Note: This appointment needs confirmation from the clinic to become final.'
                                          .tr(),
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        height: 1.5,
                                        color: colors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // أزرار التأكيد/الإلغاء ثابتة بالأسفل
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            // icon: const Icon(
                            //   Icons.check_rounded,
                            //   color: Colors.white,
                            //   size: 18,
                            // ),
                            onPressed: onConfirm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            label: Text(
                              'Confirm'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed:
                              onCancel ?? () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel'.tr(),
                            style: TextStyle(
                              color: colors.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
