import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/appointments/presentation/pages/booking_confirmation_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// شاشة اختيار اليوم والوقت — نهاية مسار الاستشارة ومسار المتابعة الاثنين
/// بيوصلوا هون. الخطوة 3 من 3. بيقدر المريض يحجز بس ضمن الأيام السبعة
/// القادمة، فما في تنقل بين شهور فعلي - إذا الأيام السبعة امتدت عبر
/// شهرين، بس بيتحسب ذلك تلقائياً وينعرض كنص فوق صف الأيام.
///
/// نفس الشاشة معادة استخدامها لإعادة جدولة موعد موجود (`isReschedule =
/// true`) - بهالوضع ما منعرض شريط تقدّم الخطوات (مش جزء من مسار حجز
/// جديد)، وعند التأكيد منرجع التاريخ/الوقت المختارين مباشرة عبر
/// [onDateTimeSelected] بدل ما نفتح شاشة تأكيد الحجز.
class SelectDateTimePage extends StatefulWidget {
  final bool isReschedule;
  final void Function(DateTime date, String time)? onDateTimeSelected;

  const SelectDateTimePage({
    super.key,
    this.isReschedule = false,
    this.onDateTimeSelected,
  });

  @override
  State<SelectDateTimePage> createState() => _SelectDateTimePageState();
}

class _SelectDateTimePageState extends State<SelectDateTimePage> {
  static const _weekdayKeys = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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

  // TODO: بيانات تجريبية لحد ما توصل الشاشة مع الـ backend الحقيقي - كل
  // يوم المفروض يجيب أوقاته المتاحة الفعلية من السيرفر (ومنطقياً لازم
  // تختلف الأوقات المتاحة من يوم لتاني).
  static const List<String> _mockTimeSlots = [
    '9:00 AM',
    '10:30 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '3:00 PM',
  ];

  // عرض كل خانة يوم (ثابت بغض النظر عن حجم البطاقة الفعلي جواتها) +
  // المسافة بينهم - لازم يطابقوا القيم المستخدمة فعلياً بالـ ListView
  // تحت، لأنه عليهم بيتبنى حساب التمرير لمنتصف اليوم المختار.
  static const double _daySlotWidth = 60;
  static const double _daySlotSpacing = 8;

  late final List<DateTime> _availableDays;
  int _selectedDayIndex = 3;
  String? _selectedTime;
  final ScrollController _dayScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    _availableDays = List.generate(
      7,
      (i) => startOfToday.add(Duration(days: i)),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelectedDay());
  }

  @override
  void dispose() {
    _dayScrollController.dispose();
    super.dispose();
  }

  // بيحسب أد إيش لازم "يصغّر" اليوم حسب بعده عن اليوم المختار - نفس
  // فكرة الصورة يلي بعتتيها (اليوم بالنص أكبر شي، وكل ما ابتعدنا يصغر).
  double _scaleForDistance(int distance) {
    if (distance <= 0) return 1.0;
    if (distance == 1) return 0.88;
    if (distance == 2) return 0.78;
    return 0.7;
  }

  void _centerSelectedDay() {
    if (!_dayScrollController.hasClients) return;
    final viewportWidth = _dayScrollController.position.viewportDimension;
    const stride = _daySlotWidth + _daySlotSpacing;
    final itemCenter = _selectedDayIndex * stride + _daySlotWidth / 2;
    final targetOffset = itemCenter - viewportWidth / 2;
    _dayScrollController.animateTo(
      targetOffset.clamp(0.0, _dayScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String _weekdayLabel(int index, DateTime date) {
    if (index == 0) return 'Today'.tr();
    if (index == 1) return 'Tomorrow'.tr();
    return _weekdayKeys[date.weekday - 1].tr();
  }

  String _monthLabel(DateTime date) => _monthKeys[date.month - 1].tr();

  String get _monthHeaderLabel {
    final months = <String>{};
    for (final day in _availableDays) {
      months.add(_monthLabel(day));
    }
    return months.join(' - ');
  }

  void _selectDay(int index) {
    setState(() {
      _selectedDayIndex = index;
      _selectedTime = null; // الأوقات ممكن تختلف من يوم لتاني
    });
    _centerSelectedDay();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
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
          (widget.isReschedule ? 'Reschedule Appointment' : 'Book New Appointment')
              .tr(),
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
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!widget.isReschedule) ...[
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Select Date & Time'.tr(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colors.onSurface.withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Step 3 of 3'.tr(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: 1),
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, _) =>
                                    LinearProgressIndicator(
                                      value: value,
                                      minHeight: 6,
                                      backgroundColor: colors.primary
                                          .withOpacity(0.15),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        colors.primary,
                                      ),
                                    ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 28),

                          FadeSlideIn(
                            child: Text(
                              'Choose your preferred date and time'.tr(),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colors.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 60),
                            child: Text(
                              'You can book an appointment within the next 7 days.'
                                  .tr(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurface.withOpacity(0.65),
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // شارة الشهر (أو الشهرين) - عرض بس، مش قابلة للضغط.
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 120),
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _monthHeaderLabel,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // صف الأيام السبعة المتاحة فقط. كل يوم إله "خانة"
                          // بعرض ثابت (_daySlotWidth) حتى المسافات تضل منتظمة،
                          // بس البطاقة جوا الخانة بتكبر/تصغر حسب بعدها عن اليوم
                          // المختار (نفس تأثير الصورة يلي بعتتيها).
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 160),
                            child: SizedBox(
                              height: 76,
                              child: ListView.separated(
                                controller: _dayScrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: _availableDays.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: _daySlotSpacing),
                                itemBuilder: (context, index) {
                                  final day = _availableDays[index];
                                  final isSelected = index == _selectedDayIndex;
                                  final distance = (index - _selectedDayIndex)
                                      .abs();
                                  final scale = _scaleForDistance(distance);

                                  return GestureDetector(
                                    onTap: () => _selectDay(index),
                                    behavior: HitTestBehavior.opaque,
                                    child: SizedBox(
                                      width: _daySlotWidth,
                                      height: 76,
                                      child: Center(
                                        child: AnimatedScale(
                                          scale: scale,
                                          duration: const Duration(
                                            milliseconds: 220,
                                          ),
                                          curve: Curves.easeOut,
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 220,
                                            ),
                                            padding: EdgeInsets.all(
                                              isSelected ? 1 : 0,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(19),
                                              border: isSelected
                                                  ? Border.all(
                                                      color: colors.primary
                                                          .withOpacity(0.35),
                                                      width: 2,
                                                    )
                                                  : null,
                                            ),
                                            child: Container(
                                              width: 56,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? colors.primary
                                                    : colors.surface,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: isSelected
                                                    ? []
                                                    : [
                                                        BoxShadow(
                                                          color: colors.shadow
                                                              .withOpacity(
                                                                isDark
                                                                    ? 0.30
                                                                    : 0.10,
                                                              ),
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                            0,
                                                            3,
                                                          ),
                                                        ),
                                                      ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${day.day}',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : colors.onSurface,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    _weekdayLabel(index, day),
                                                    style: TextStyle(
                                                      fontSize: 10.5,
                                                      color: isSelected
                                                          ? Colors.white
                                                                .withOpacity(
                                                                  0.85,
                                                                )
                                                          : colors.onSurface
                                                                .withOpacity(
                                                                  0.6,
                                                                ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  AnimatedOpacity(
                                                    duration: const Duration(
                                                      milliseconds: 200,
                                                    ),
                                                    opacity: isSelected ? 1 : 0,
                                                    child: Container(
                                                      width: 5,
                                                      height: 5,
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          FadeSlideIn(
                            delay: const Duration(milliseconds: 220),
                            child: Text(
                              'Select Time'.tr(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurface.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 260),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: _mockTimeSlots.map((time) {
                                final isSelected = _selectedTime == time;
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedTime = time),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? colors.primary.withOpacity(0.12)
                                          : colors.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? colors.primary
                                            : colors.outline.withOpacity(0.25),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          size: 15,
                                          color: isSelected
                                              ? colors.primary
                                              : colors.onSurface.withOpacity(
                                                  0.5,
                                                ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          time,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? colors.primary
                                                : colors.onSurface.withOpacity(
                                                    0.75,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // زر التأكيد ثابت بالأسفل، معطّل لحد ما يختار يوم ووقت.
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        // icon: const Icon(
                        //   Icons.arrow_forward,
                        //   color: Colors.white,
                        //   size: 18,
                        // ),
                        onPressed: _selectedTime != null
                            ? () {
                                if (widget.isReschedule) {
                                  widget.onDateTimeSelected?.call(
                                    _availableDays[_selectedDayIndex],
                                    _selectedTime!,
                                  );
                                  Navigator.of(context).pop();
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingConfirmationPage(
                                      visitTypeLabel:
                                          'موعد استشارة', // TODO: مؤقت لحد ما نربط القيمة الحقيقية من شاشة نوع الزيارة
                                      date: _availableDays[_selectedDayIndex],
                                      time: _selectedTime!,
                                      onConfirm: () {
                                        // TODO: تنفيذ تأكيد الحجز الفعلي
                                      },
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          disabledBackgroundColor: colors.primary.withOpacity(
                            0.35,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        label: Text(
                          (widget.isReschedule
                                  ? 'Confirm New Date'
                                  : 'Continue to confirm booking')
                              .tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
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
