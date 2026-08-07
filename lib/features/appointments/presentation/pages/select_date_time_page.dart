import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/appointments/data/mock_appointments_store.dart';
import 'package:dental_app/features/appointments/data/models/appointment_model.dart';
import 'package:dental_app/features/appointments/data/models/appointment_status.dart';
import 'package:dental_app/features/appointments/presentation/pages/booking_confirmation_page.dart';
import 'package:dental_app/features/home/presentation/pages/main_navigation_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dental_app/features/appointments/presentation/utils/appointment_date_format.dart'
    as date_fmt;

/// شاشة اختيار اليوم والوقت — نهاية مسار الاستشارة ومسار المتابعة الاثنين
/// بيوصلوا هون. الخطوة 3 من 3.
///
/// عدد الأيام المتاحة للحجز مقدماً ([_bookableDaysAhead]) بيتحكم فيه
/// الطبيب من الداش بورد (7/15/30/60 يوم مثلاً - TODO: يجي من إعدادات
/// العيادة عبر الـ backend، مؤقتاً ثابت هون كـ mock). المريض بيشوف
/// كالندر شهري كامل، الأيام يلي برا نافذة الحجز المسموحة (سواء فاتت
/// أو بعد آخر يوم مسموح) بتطلع بلون رمادي وما بتنضغط، وبيقدر يتنقل بين
/// الشهور بس ضمن حدود النافذة هاي.
///
/// نفس الشاشة معادة استخدامها لإعادة جدولة موعد موجود (`isReschedule =
/// true`) - بهالوضع ما منعرض شريط تقدّم الخطوات (مش جزء من مسار حجز
/// جديد)، وعند التأكيد منرجع التاريخ/الوقت المختارين مباشرة عبر
/// [onDateTimeSelected] بدل ما نفتح شاشة تأكيد الحجز.
class SelectDateTimePage extends StatefulWidget {
  final bool isReschedule;
  final void Function(DateTime date, String time)? onDateTimeSelected;

  /// نوع الزيارة (أو اسم الجلسة لو مسار متابعة) يلي بيتعرض بشاشة تأكيد
  /// الحجز بعدها. مش لازمة بوضع isReschedule (ما في شاشة تأكيد جديدة
  /// بهاد الوضع).
  final String? visitTypeLabel;

  const SelectDateTimePage({
    super.key,
    this.isReschedule = false,
    this.onDateTimeSelected,
    this.visitTypeLabel,
  });

  @override
  State<SelectDateTimePage> createState() => _SelectDateTimePageState();
}

class _SelectDateTimePageState extends State<SelectDateTimePage> {
  static const _weekdayKeys = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  // فهرس الجمعة والسبت بمصفوفة تبلش من الاثنين (0=اثنين...6=أحد) - نلوّنهم
  // شوي مختلف بهيدر أيام الأسبوع كتلميح لعطلة نهاية الأسبوع بالمنطقة.
  static const _weekendIndexes = {4, 5};

  // TODO: هاد الرقم لازم يجي من إعدادات الطبيب/العيادة بالداش بورد
  // (بيقدر يختار 7 أو 15 أو 30 أو 60 يوم مثلاً) - مؤقتاً ثابت كـ mock.
  static const int _bookableDaysAhead = 15;

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

  late final DateTime _todayDate;
  late final DateTime _maxBookableDate;
  late DateTime _displayedMonth; // أول يوم بالشهر المعروض حالياً بالكالندر
  late DateTime _selectedDate;
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _todayDate = DateTime(now.year, now.month, now.day);
    _maxBookableDate = _todayDate.add(
      const Duration(days: _bookableDaysAhead - 1),
    );
    _selectedDate = _todayDate;
    _displayedMonth = DateTime(_todayDate.year, _todayDate.month);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// اليوم قابل للحجز إذا كان بين اليوم الحالي وآخر يوم مسموح فيه
  /// (نافذة الحجز المقدّمة من الطبيب) - أي يوم فات أو تجاوز النافذة
  /// بيطلع رمادي وممنوع الضغط عليه.
  bool _isBookable(DateTime day) =>
      !day.isBefore(_todayDate) && !day.isAfter(_maxBookableDate);

  bool get _canGoToPreviousMonth {
    final lastDayOfPrevMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      0,
    );
    return !lastDayOfPrevMonth.isBefore(_todayDate);
  }

  bool get _canGoToNextMonth {
    final firstDayOfNextMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      1,
    );
    return !firstDayOfNextMonth.isAfter(_maxBookableDate);
  }

  /// true إذا كان المستخدم شايف شهر اليوم الحالي ومحدد اليوم الحالي -
  /// بيتحكم بظهور زر "اليوم" السريع (ما في داعي نعرضه إذا هو أصلاً
  /// واقف عند اليوم).
  bool get _isViewingToday {
    final displayedIsCurrentMonth =
        _displayedMonth.year == _todayDate.year &&
        _displayedMonth.month == _todayDate.month;
    return displayedIsCurrentMonth && _isSameDay(_selectedDate, _todayDate);
  }

  void _goToPreviousMonth() {
    if (!_canGoToPreviousMonth) return;
    setState(
      () => _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      ),
    );
  }

  void _goToNextMonth() {
    if (!_canGoToNextMonth) return;
    setState(
      () => _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      ),
    );
  }

  void _selectDate(DateTime day) {
    if (!_isBookable(day)) return;
    setState(() {
      _selectedDate = day;
      _selectedTime = null; // الأوقات ممكن تختلف من يوم لتاني
    });
  }

  void _jumpToToday() {
    setState(() {
      _displayedMonth = DateTime(_todayDate.year, _todayDate.month);
      _selectedDate = _todayDate;
      _selectedTime = null;
    });
  }

  /// بعد تأكيد الحجز (mock): بنضيف الموعد لمخزن الجلسة، منسكّر كل
  /// شاشات مسار الحجز، ومنفتح تبويب مواعيدي حتى يشوف المريض موعده.
  void _confirmBooking(
    BuildContext context, {
    required String visitTypeLabel,
    required DateTime date,
    required String time,
  }) {
    // TODO: استبدال بـ API call حقيقي لإنشاء الموعد.
    final timeParts = _parseTimeOfDay(time);
    final scheduledAt = DateTime(
      date.year,
      date.month,
      date.day,
      timeParts.hour,
      timeParts.minute,
    );

    MockAppointmentsStore.instance.add(
      Appointment(
        id: 'apt-${DateTime.now().millisecondsSinceEpoch}',
        visitTypeLabel: visitTypeLabel,
        doctorName: 'د. سمير إبراهيم',
        doctorSpecialty: 'General Dentist'.tr(),
        scheduledAt: scheduledAt,
        // ملاحظة شاشة التأكيد: الموعد بحاجة لتأكيد العيادة.
        status: AppointmentStatus.pendingConfirmation,
      ),
    );

    // منسكّر مسار الحجز لحد ما نوصل لـ MainNavigation (ما منطلع
    // لشاشات الأونبوردنغ/اللغة يلي كانت تحتها بالستاك القديم).
    Navigator.of(context).popUntil(
      (route) =>
          route.settings.name == MainNavigationPage.routeName || route.isFirst,
    );
    MainNavigationPage.goToAppointmentsTab();
  }

  ({int hour, int minute}) _parseTimeOfDay(String label) {
    final isPm = label.toUpperCase().contains('PM');
    final digitsPart = label.replaceAll(RegExp(r'[^0-9:]'), '');
    final parts = digitsPart.split(':');
    var hour = int.tryParse(parts.first) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    if (isPm && hour != 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;
    return (hour: hour, minute: minute);
  }

  /// بيبني شبكة أيام الشهر (مضاعفات ٧ - أسبوع كامل بالسطر) مع خانات
  /// فاضية (null) قبل أول يوم وبعد آخر يوم حتى الشبكة تبلش من الاثنين
  /// متل هيدر أسماء الأيام.
  List<DateTime?> _buildMonthGrid(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingBlanks = firstDayOfMonth.weekday - 1; // Monday = 1
    final cells = <DateTime?>[
      ...List<DateTime?>.filled(leadingBlanks, null),
      for (var d = 1; d <= daysInMonth; d++)
        DateTime(month.year, month.month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    return cells;
  }

  String get _monthYearLabel =>
      '${date_fmt.monthKeys[_displayedMonth.month - 1].tr()} ${_displayedMonth.year}';

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
          (widget.isReschedule
                  ? 'Reschedule Appointment'
                  : 'Book New Appointment')
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              'You can book an appointment within the next {days} days.'
                                  .tr(
                                    namedArgs: {'days': '$_bookableDaysAhead'},
                                  ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurface.withOpacity(0.65),
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // كارد الكالندر الشهري - زر "اليوم" السريع (لما
                          // نكون بعيدين عن اليوم الحالي)، هيدر فيه اسم
                          // الشهر والسنة مع أسهم تنقل (معطّلة تلقائياً لما
                          // نطلع برا نافذة الحجز المسموحة)، وتحته صف رؤوس
                          // أيام الأسبوع (الجمعة/السبت بلون مختلف شوي)،
                          // وتحته شبكة أيام الشهر بأنيميشن انتقال ناعم لما
                          // نبدّل شهر.
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 120),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                12,
                                12,
                                12,
                                16,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.shadow.withOpacity(
                                      isDark ? 0.30 : 0.10,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                    child: _isViewingToday
                                        ? const SizedBox.shrink()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8,
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional
                                                  .centerEnd,
                                              child: _TodayChip(
                                                onTap: _jumpToToday,
                                              ),
                                            ),
                                          ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _MonthNavButton(
                                        icon: Icons.chevron_left_rounded,
                                        onTap: _canGoToPreviousMonth
                                            ? _goToPreviousMonth
                                            : null,
                                      ),
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 220,
                                        ),
                                        child: Text(
                                          _monthYearLabel,
                                          key: ValueKey<String>(
                                            _monthYearLabel,
                                          ),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: colors.onSurface,
                                          ),
                                        ),
                                      ),
                                      _MonthNavButton(
                                        icon: Icons.chevron_right_rounded,
                                        onTap: _canGoToNextMonth
                                            ? _goToNextMonth
                                            : null,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: List.generate(
                                      _weekdayKeys.length,
                                      (index) => Expanded(
                                        child: Center(
                                          child: Text(
                                            _weekdayKeys[index].tr(),
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  _weekendIndexes.contains(
                                                    index,
                                                  )
                                                  ? colors.primary.withOpacity(
                                                      0.55,
                                                    )
                                                  : colors.onSurface
                                                        .withOpacity(0.45),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 240),
                                    transitionBuilder: (child, animation) =>
                                        FadeTransition(
                                          opacity: animation,
                                          child: ScaleTransition(
                                            scale: Tween<double>(
                                              begin: 0.96,
                                              end: 1,
                                            ).animate(animation),
                                            child: child,
                                          ),
                                        ),
                                    child: GridView.count(
                                      key: ValueKey<String>(_monthYearLabel),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      crossAxisCount: 7,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 2,
                                      childAspectRatio: 1,
                                      children: _buildMonthGrid(_displayedMonth)
                                          .map((day) {
                                            if (day == null) {
                                              return const SizedBox.shrink();
                                            }
                                            return _DayCell(
                                              day: day,
                                              isBookable: _isBookable(day),
                                              isSelected: _isSameDay(
                                                day,
                                                _selectedDate,
                                              ),
                                              isToday: _isSameDay(
                                                day,
                                                _todayDate,
                                              ),
                                              onTap: () => _selectDate(day),
                                            );
                                          })
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 160),
                            child: Text(
                              'Unavailable dates are grayed out.'.tr(),
                              style: TextStyle(
                                fontSize: 11.5,
                                color: colors.onSurface.withOpacity(0.45),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // شريط صغير بيلخص التاريخ المختار حالياً - بيعطي
                          // تأكيد بصري واضح قبل ما ينزل المريض لقسم الوقت.
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 200),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: Container(
                                key: ValueKey<DateTime>(_selectedDate),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      colors.primary.withOpacity(0.10),
                                      colors.secondary.withOpacity(0.10),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.event_available_rounded,
                                      size: 18,
                                      color: colors.primary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        date_fmt.formatAppointmentDate(
                                          _selectedDate,
                                        ),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: colors.onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

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
                                          date_fmt.formatMockTimeLabel(time),
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
                        onPressed: _selectedTime != null
                            ? () {
                                if (widget.isReschedule) {
                                  widget.onDateTimeSelected?.call(
                                    _selectedDate,
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
                                          widget.visitTypeLabel ??
                                          'موعد استشارة', // احتياطي لو ما انمررت من الشاشة السابقة
                                      date: _selectedDate,
                                      time: _selectedTime!,
                                      onConfirm: () => _confirmBooking(
                                        context,
                                        visitTypeLabel:
                                            widget.visitTypeLabel ??
                                            'موعد استشارة',
                                        date: _selectedDate,
                                        time: _selectedTime!,
                                      ),
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

/// شارة "اليوم" السريعة - بتظهر جوا كارد الكالندر بس لما يكون المستخدم
/// بعيد عن اليوم الحالي (شهر مختلف أو تاريخ مختار مختلف)، وبتاخده
/// فوراً لليوم الحالي بضغطة واحدة.
class _TodayChip extends StatelessWidget {
  final VoidCallback onTap;

  const _TodayChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: colors.primary.withOpacity(0.10),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.today_rounded, size: 13, color: colors.primary),
            const SizedBox(width: 4),
            Text(
              'Today'.tr(),
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// سهم تنقل بين الشهور بكارد الكالندر - بيطلع باهت وغير قابل للضغط
/// (onTap null) لما يكون التنقل بيطلع برا نافذة الحجز المسموحة، وبظل
/// خفيف لما يكون فعّال حتى يحس المستخدم إنه "قابل للضغط" بوضوح.
class _MonthNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _MonthNavButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled
              ? colors.primary.withOpacity(0.10)
              : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? colors.primary : colors.onSurface.withOpacity(0.18),
        ),
      ),
    );
  }
}

/// خانة يوم واحد بشبكة الكالندر. الأيام غير القابلة للحجز ([isBookable]
/// false) بتطلع بلون رمادي باهت وما بتستجيب للضغط. اليوم المختار بيتعبى
/// بتدرج لوني (نفس عيلة تدرج كارد الموعد القادم بالرئيسية) بدل لون فلات،
/// مع أنيميشن "نبضة" خفيفة لما يتحدد.
class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool isBookable;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isBookable,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isBookable ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: isSelected ? 1 : 0),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          builder: (context, scaleBoost, child) {
            final scale = isSelected ? 0.9 + scaleBoost * 0.1 : 1.0;
            return Transform.scale(scale: scale, child: child);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colors.primary, colors.secondary],
                    )
                  : null,
              border: (!isSelected && isToday)
                  ? Border.all(
                      color: colors.primary.withOpacity(0.5),
                      width: 1.4,
                    )
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colors.primary.withOpacity(0.30),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isSelected || isToday
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isBookable
                          ? colors.onSurface
                          : colors.onSurface.withOpacity(0.22)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:dental_app/core/widgets/fade_slide_in.dart';
// import 'package:dental_app/features/appointments/presentation/pages/booking_confirmation_page.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:dental_app/features/appointments/presentation/utils/appointment_date_format.dart'
//     as date_fmt;

// /// شاشة اختيار اليوم والوقت — نهاية مسار الاستشارة ومسار المتابعة الاثنين
// /// بيوصلوا هون. الخطوة 3 من 3.
// ///
// /// عدد الأيام المتاحة للحجز مقدماً ([_bookableDaysAhead]) بيتحكم فيه
// /// الطبيب من الداش بورد (7/15/30/60 يوم مثلاً - TODO: يجي من إعدادات
// /// العيادة عبر الـ backend، مؤقتاً ثابت هون كـ mock). المريض بيشوف
// /// كالندر شهري كامل، الأيام يلي برا نافذة الحجز المسموحة (سواء فاتت
// /// أو بعد آخر يوم مسموح) بتطلع بلون رمادي وما بتنضغط، وبيقدر يتنقل بين
// /// الشهور بس ضمن حدود النافذة هاي.
// ///
// /// نفس الشاشة معادة استخدامها لإعادة جدولة موعد موجود (`isReschedule =
// /// true`) - بهالوضع ما منعرض شريط تقدّم الخطوات (مش جزء من مسار حجز
// /// جديد)، وعند التأكيد منرجع التاريخ/الوقت المختارين مباشرة عبر
// /// [onDateTimeSelected] بدل ما نفتح شاشة تأكيد الحجز.
// class SelectDateTimePage extends StatefulWidget {
//   final bool isReschedule;
//   final void Function(DateTime date, String time)? onDateTimeSelected;

//   /// نوع الزيارة (أو اسم الجلسة لو مسار متابعة) يلي بيتعرض بشاشة تأكيد
//   /// الحجز بعدها. مش لازمة بوضع isReschedule (ما في شاشة تأكيد جديدة
//   /// بهاد الوضع).
//   final String? visitTypeLabel;

//   const SelectDateTimePage({
//     super.key,
//     this.isReschedule = false,
//     this.onDateTimeSelected,
//     this.visitTypeLabel,
//   });

//   @override
//   State<SelectDateTimePage> createState() => _SelectDateTimePageState();
// }

// class _SelectDateTimePageState extends State<SelectDateTimePage> {
//   static const _weekdayKeys = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

//   // TODO: هاد الرقم لازم يجي من إعدادات الطبيب/العيادة بالداش بورد
//   // (بيقدر يختار 7 أو 15 أو 30 أو 60 يوم مثلاً) - مؤقتاً ثابت كـ mock.
//   static const int _bookableDaysAhead = 15;

//   // TODO: بيانات تجريبية لحد ما توصل الشاشة مع الـ backend الحقيقي - كل
//   // يوم المفروض يجيب أوقاته المتاحة الفعلية من السيرفر (ومنطقياً لازم
//   // تختلف الأوقات المتاحة من يوم لتاني).
//   static const List<String> _mockTimeSlots = [
//     '9:00 AM',
//     '10:30 AM',
//     '11:00 AM',
//     '12:00 PM',
//     '1:00 PM',
//     '3:00 PM',
//   ];

//   late final DateTime _todayDate;
//   late final DateTime _maxBookableDate;
//   late DateTime _displayedMonth; // أول يوم بالشهر المعروض حالياً بالكالندر
//   late DateTime _selectedDate;
//   String? _selectedTime;

//   @override
//   void initState() {
//     super.initState();
//     final now = DateTime.now();
//     _todayDate = DateTime(now.year, now.month, now.day);
//     _maxBookableDate = _todayDate.add(
//       const Duration(days: _bookableDaysAhead - 1),
//     );
//     _selectedDate = _todayDate;
//     _displayedMonth = DateTime(_todayDate.year, _todayDate.month);
//   }

//   bool _isSameDay(DateTime a, DateTime b) =>
//       a.year == b.year && a.month == b.month && a.day == b.day;

//   /// اليوم قابل للحجز إذا كان بين اليوم الحالي وآخر يوم مسموح فيه
//   /// (نافذة الحجز المقدّمة من الطبيب) - أي يوم فات أو تجاوز النافذة
//   /// بيطلع رمادي وممنوع الضغط عليه.
//   bool _isBookable(DateTime day) =>
//       !day.isBefore(_todayDate) && !day.isAfter(_maxBookableDate);

//   bool get _canGoToPreviousMonth {
//     final lastDayOfPrevMonth = DateTime(
//       _displayedMonth.year,
//       _displayedMonth.month,
//       0,
//     );
//     return !lastDayOfPrevMonth.isBefore(_todayDate);
//   }

//   bool get _canGoToNextMonth {
//     final firstDayOfNextMonth = DateTime(
//       _displayedMonth.year,
//       _displayedMonth.month + 1,
//       1,
//     );
//     return !firstDayOfNextMonth.isAfter(_maxBookableDate);
//   }

//   void _goToPreviousMonth() {
//     if (!_canGoToPreviousMonth) return;
//     setState(
//       () => _displayedMonth = DateTime(
//         _displayedMonth.year,
//         _displayedMonth.month - 1,
//       ),
//     );
//   }

//   void _goToNextMonth() {
//     if (!_canGoToNextMonth) return;
//     setState(
//       () => _displayedMonth = DateTime(
//         _displayedMonth.year,
//         _displayedMonth.month + 1,
//       ),
//     );
//   }

//   void _selectDate(DateTime day) {
//     if (!_isBookable(day)) return;
//     setState(() {
//       _selectedDate = day;
//       _selectedTime = null; // الأوقات ممكن تختلف من يوم لتاني
//     });
//   }

//   /// بيبني شبكة أيام الشهر (مضاعفات ٧ - أسبوع كامل بالسطر) مع خانات
//   /// فاضية (null) قبل أول يوم وبعد آخر يوم حتى الشبكة تبلش من الاثنين
//   /// متل هيدر أسماء الأيام.
//   List<DateTime?> _buildMonthGrid(DateTime month) {
//     final firstDayOfMonth = DateTime(month.year, month.month, 1);
//     final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
//     final leadingBlanks = firstDayOfMonth.weekday - 1; // Monday = 1
//     final cells = <DateTime?>[
//       ...List<DateTime?>.filled(leadingBlanks, null),
//       for (var d = 1; d <= daysInMonth; d++) DateTime(month.year, month.month, d),
//     ];
//     while (cells.length % 7 != 0) {
//       cells.add(null);
//     }
//     return cells;
//   }

//   String get _monthYearLabel =>
//       '${date_fmt.monthKeys[_displayedMonth.month - 1].tr()} ${_displayedMonth.year}';

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;
//     final isDark = theme.brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: colors.surfaceContainerHighest,
//       appBar: AppBar(
//         backgroundColor: colors.surfaceContainerHighest,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_forward, color: colors.onSurface),
//           onPressed: () => Navigator.of(context).maybePop(),
//         ),
//         title: Text(
//           (widget.isReschedule
//                   ? 'Reschedule Appointment'
//                   : 'Book New Appointment')
//               .tr(),
//           style: theme.textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.w700,
//             color: colors.onSurface,
//           ),
//         ),
//       ),
//       body: SizedBox.expand(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Image.asset(
//                 'assets/backgrounds/background3.png',
//                 fit: BoxFit.cover,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//             SafeArea(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           if (!widget.isReschedule) ...[
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Select Date & Time'.tr(),
//                                   style: theme.textTheme.bodyMedium?.copyWith(
//                                     color: colors.onSurface.withOpacity(0.7),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Step 3 of 3'.tr(),
//                                   style: theme.textTheme.bodyMedium?.copyWith(
//                                     color: colors.primary,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: TweenAnimationBuilder<double>(
//                                 tween: Tween(begin: 0, end: 1),
//                                 duration: const Duration(milliseconds: 700),
//                                 curve: Curves.easeOutCubic,
//                                 builder: (context, value, _) =>
//                                     LinearProgressIndicator(
//                                       value: value,
//                                       minHeight: 6,
//                                       backgroundColor: colors.primary
//                                           .withOpacity(0.15),
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                         colors.primary,
//                                       ),
//                                     ),
//                               ),
//                             ),
//                           ],

//                           const SizedBox(height: 28),

//                           FadeSlideIn(
//                             child: Text(
//                               'Choose your preferred date and time'.tr(),
//                               style: theme.textTheme.headlineSmall?.copyWith(
//                                 fontWeight: FontWeight.w700,
//                                 color: colors.onSurface,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           FadeSlideIn(
//                             delay: const Duration(milliseconds: 60),
//                             child: Text(
//                               'You can book an appointment within the next {days} days.'
//                                   .tr(
//                                     namedArgs: {
//                                       'days': '$_bookableDaysAhead',
//                                     },
//                                   ),
//                               style: theme.textTheme.bodyMedium?.copyWith(
//                                 color: colors.onSurface.withOpacity(0.65),
//                                 height: 1.4,
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 20),

//                           // كارد الكالندر الشهري - هيدر فيه اسم الشهر
//                           // والسنة مع أسهم تنقل (معطّلة تلقائياً لما نطلع
//                           // برا نافذة الحجز المسموحة)، وتحته صف رؤوس أيام
//                           // الأسبوع، وتحته شبكة أيام الشهر. الأيام الرمادية
//                           // برا نافذة الحجز وممنوع الضغط عليها.
//                           FadeSlideIn(
//                             delay: const Duration(milliseconds: 120),
//                             child: Container(
//                               padding: const EdgeInsets.fromLTRB(
//                                 12,
//                                 12,
//                                 12,
//                                 16,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: colors.surface,
//                                 borderRadius: BorderRadius.circular(22),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: colors.shadow.withOpacity(
//                                       isDark ? 0.30 : 0.10,
//                                     ),
//                                     blurRadius: 12,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       _MonthNavButton(
//                                         icon: Icons.chevron_left_rounded,
//                                         onTap: _canGoToPreviousMonth
//                                             ? _goToPreviousMonth
//                                             : null,
//                                       ),
//                                       Text(
//                                         _monthYearLabel,
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w700,
//                                           color: colors.onSurface,
//                                         ),
//                                       ),
//                                       _MonthNavButton(
//                                         icon: Icons.chevron_right_rounded,
//                                         onTap: _canGoToNextMonth
//                                             ? _goToNextMonth
//                                             : null,
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 12),
//                                   Row(
//                                     children: _weekdayKeys
//                                         .map(
//                                           (key) => Expanded(
//                                             child: Center(
//                                               child: Text(
//                                                 key.tr(),
//                                                 style: TextStyle(
//                                                   fontSize: 11.5,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: colors.onSurface
//                                                       .withOpacity(0.45),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                         .toList(),
//                                   ),
//                                   const SizedBox(height: 6),
//                                   GridView.count(
//                                     shrinkWrap: true,
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     crossAxisCount: 7,
//                                     mainAxisSpacing: 4,
//                                     crossAxisSpacing: 2,
//                                     childAspectRatio: 1,
//                                     children: _buildMonthGrid(_displayedMonth)
//                                         .map((day) {
//                                           if (day == null) {
//                                             return const SizedBox.shrink();
//                                           }
//                                           return _DayCell(
//                                             day: day,
//                                             isBookable: _isBookable(day),
//                                             isSelected: _isSameDay(
//                                               day,
//                                               _selectedDate,
//                                             ),
//                                             isToday: _isSameDay(
//                                               day,
//                                               _todayDate,
//                                             ),
//                                             onTap: () => _selectDate(day),
//                                           );
//                                         })
//                                         .toList(),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 8),
//                           FadeSlideIn(
//                             delay: const Duration(milliseconds: 160),
//                             child: Text(
//                               'Unavailable dates are grayed out.'.tr(),
//                               style: TextStyle(
//                                 fontSize: 11.5,
//                                 color: colors.onSurface.withOpacity(0.45),
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 28),

//                           FadeSlideIn(
//                             delay: const Duration(milliseconds: 220),
//                             child: Text(
//                               'Select Time'.tr(),
//                               style: theme.textTheme.bodyMedium?.copyWith(
//                                 color: colors.onSurface.withOpacity(0.7),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           FadeSlideIn(
//                             delay: const Duration(milliseconds: 260),
//                             child: Wrap(
//                               spacing: 10,
//                               runSpacing: 10,
//                               children: _mockTimeSlots.map((time) {
//                                 final isSelected = _selectedTime == time;
//                                 return GestureDetector(
//                                   onTap: () =>
//                                       setState(() => _selectedTime = time),
//                                   child: AnimatedContainer(
//                                     duration: const Duration(milliseconds: 200),
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 14,
//                                       vertical: 10,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: isSelected
//                                           ? colors.primary.withOpacity(0.12)
//                                           : colors.surface,
//                                       borderRadius: BorderRadius.circular(12),
//                                       border: Border.all(
//                                         color: isSelected
//                                             ? colors.primary
//                                             : colors.outline.withOpacity(0.25),
//                                       ),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Icon(
//                                           Icons.access_time_rounded,
//                                           size: 15,
//                                           color: isSelected
//                                               ? colors.primary
//                                               : colors.onSurface.withOpacity(
//                                                   0.5,
//                                                 ),
//                                         ),
//                                         const SizedBox(width: 6),
//                                         Text(
//                                           date_fmt.formatMockTimeLabel(time),
//                                           style: TextStyle(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w600,
//                                             color: isSelected
//                                                 ? colors.primary
//                                                 : colors.onSurface.withOpacity(
//                                                     0.75,
//                                                   ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // زر التأكيد ثابت بالأسفل، معطّل لحد ما يختار يوم ووقت.
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: _selectedTime != null
//                             ? () {
//                                 if (widget.isReschedule) {
//                                   widget.onDateTimeSelected?.call(
//                                     _selectedDate,
//                                     _selectedTime!,
//                                   );
//                                   Navigator.of(context).pop();
//                                   return;
//                                 }
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => BookingConfirmationPage(
//                                       visitTypeLabel:
//                                           widget.visitTypeLabel ??
//                                           'موعد استشارة', // احتياطي لو ما انمررت من الشاشة السابقة
//                                       date: _selectedDate,
//                                       time: _selectedTime!,
//                                       onConfirm: () {
//                                         // TODO: تنفيذ تأكيد الحجز الفعلي
//                                       },
//                                     ),
//                                   ),
//                                 );
//                               }
//                             : null,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: colors.primary,
//                           disabledBackgroundColor: colors.primary.withOpacity(
//                             0.35,
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         label: Text(
//                           (widget.isReschedule
//                                   ? 'Confirm New Date'
//                                   : 'Continue to confirm booking')
//                               .tr(),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// سهم تنقل بين الشهور بكارد الكالندر - بيطلع باهت وغير قابل للضغط
// /// (onTap null) لما يكون التنقل بيطلع برا نافذة الحجز المسموحة.
// class _MonthNavButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback? onTap;

//   const _MonthNavButton({required this.icon, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final enabled = onTap != null;

//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: Container(
//         width: 32,
//         height: 32,
//         decoration: BoxDecoration(
//           color: enabled ? colors.primary.withOpacity(0.10) : Colors.transparent,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           icon,
//           size: 20,
//           color: enabled ? colors.primary : colors.onSurface.withOpacity(0.18),
//         ),
//       ),
//     );
//   }
// }

// /// خانة يوم واحد بشبكة الكالندر. الأيام غير القابلة للحجز ([isBookable]
// /// false) بتطلع بلون رمادي باهت وما بتستجيب للضغط.
// class _DayCell extends StatelessWidget {
//   final DateTime day;
//   final bool isBookable;
//   final bool isSelected;
//   final bool isToday;
//   final VoidCallback onTap;

//   const _DayCell({
//     required this.day,
//     required this.isBookable,
//     required this.isSelected,
//     required this.isToday,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return GestureDetector(
//       onTap: isBookable ? onTap : null,
//       behavior: HitTestBehavior.opaque,
//       child: Center(
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           width: 34,
//           height: 34,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: isSelected ? colors.primary : Colors.transparent,
//             border: (!isSelected && isToday)
//                 ? Border.all(color: colors.primary.withOpacity(0.5), width: 1.4)
//                 : null,
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             '${day.day}',
//             style: TextStyle(
//               fontSize: 13.5,
//               fontWeight: isSelected || isToday
//                   ? FontWeight.w700
//                   : FontWeight.w500,
//               color: isSelected
//                   ? Colors.white
//                   : (isBookable
//                         ? colors.onSurface
//                         : colors.onSurface.withOpacity(0.22)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
