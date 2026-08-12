import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/data/models/available_day.dart';
import 'package:dental_app/features/appointments/data/models/available_slot.dart';
import 'package:dental_app/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:dental_app/features/appointments/presentation/pages/booking_confirmation_page.dart';
import 'package:dental_app/features/appointments/presentation/utils/appointment_date_format.dart'
    as date_fmt;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
/// شاشة اختيار اليوم والوقت — نهاية مسار الاستشارة ومسار المتابعة.
///
/// الأيام والأوقات بتيجي من:
/// - GET appointments/availability/days
/// - GET appointments/availability/slots
///
/// الباك بيطبق نافذة الحجز، earliestBookingDate للمتابعة، وأيام العطلة.
/// الأيام يلي ما رجعت بالمصفوفة (أو hasAvailableSlots=false) بتطلع رمادية.
class SelectDateTimePage extends StatefulWidget {
  final bool isReschedule;
  final void Function(DateTime date, String time)? onDateTimeSelected;

  /// نوع الزيارة المعروض بشاشة التأكيد.
  final String? visitTypeLabel;

  /// CONSULTATION أو FOLLOW_UP — مطلوب لمسار الحجز الجديد.
  final AppointmentBookingType? bookingType;

  /// مطلوب لما [bookingType] = followUp.
  final String? treatmentSessionId;

  /// سبب الزيارة (استشارة) — يُرسل لـ POST appointments.
  final String? reasonForVisit;

  /// ملخص الشات بوت (استشارة) — يُرسل لـ POST appointments.
  final String? chatbotSummary;

  /// عند reschedule — يُرسل لـ availability كـ excludeAppointmentId.
  final String? rescheduleAppointmentId;

  const SelectDateTimePage({
    super.key,
    this.isReschedule = false,
    this.onDateTimeSelected,
    this.visitTypeLabel,
    this.bookingType,
    this.treatmentSessionId,
    this.reasonForVisit,
    this.chatbotSummary,
    this.rescheduleAppointmentId,
  });

  @override
  State<SelectDateTimePage> createState() => _SelectDateTimePageState();
}

class _SelectDateTimePageState extends State<SelectDateTimePage> {
  static const _weekdayKeys = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _weekendIndexes = {4, 5};

  late final DateTime _todayDate;
  late DateTime _displayedMonth;
  DateTime? _selectedDate;
  String? _selectedTime; // HH:mm من الـ API

  String? _patientId;
  final Map<String, AvailableDay> _daysByDate = {};
  List<AvailableSlot> _slots = [];

  bool _loadingDays = false;
  bool _loadingSlots = false;
  String? _daysError;
  String? _slotsError;
  String? _slotsEmptyHint;

  bool get _usesApi => widget.bookingType != null;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _todayDate = DateTime(now.year, now.month, now.day);
    _displayedMonth = DateTime(_todayDate.year, _todayDate.month);
    if (_usesApi) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
    }
  }

  Future<void> _bootstrap() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;
    if (patientId == null || patientId.isEmpty) {
      setState(() => _daysError = 'Patient not found.'.tr());
      return;
    }
    _patientId = patientId;
    _loadDays();
  }

  String _dateKey(DateTime d) => date_fmt.formatApiDate(d);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isBookable(DateTime day) {
    if (!_usesApi) {
      return !day.isBefore(_todayDate);
    }
    final info = _daysByDate[_dateKey(day)];
    return info?.isBookable == true;
  }

  bool get _canGoToPreviousMonth {
    final lastDayOfPrevMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      0,
    );
    return !lastDayOfPrevMonth.isBefore(_todayDate);
  }

  bool get _canGoToNextMonth {
    // الباك بيفلتر حسب maxBookingHorizonDays — منسمح تنقل للشهور الجاية.
    return true;
  }

  bool get _isViewingToday {
    if (_selectedDate == null) return false;
    final displayedIsCurrentMonth =
        _displayedMonth.year == _todayDate.year &&
        _displayedMonth.month == _todayDate.month;
    return displayedIsCurrentMonth && _isSameDay(_selectedDate!, _todayDate);
  }

  String _mapAvailabilityError(String message) => message;

  void _dispatchCreateAppointment({
    required DateTime date,
    required String time,
  }) {
    final patientId = _patientId;
    final type = widget.bookingType;
    if (patientId == null || patientId.isEmpty || type == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient not found.'.tr())),
      );
      return;
    }

    context.read<AppointmentsBloc>().add(
          CreateAppointmentRequested(
            patientId: patientId,
            type: type,
            scheduledAt: date_fmt.buildScheduledAtUtcIso(date, time),
            treatmentSessionId: widget.treatmentSessionId,
            reasonForVisit: widget.reasonForVisit,
            chatbotSummary: widget.chatbotSummary,
          ),
        );
  }

  void _loadDays() {
    if (!_usesApi) return;
    final patientId = _patientId;
    final type = widget.bookingType;
    if (patientId == null || type == null) return;

    setState(() {
      _loadingDays = true;
      _daysError = null;
      _slotsError = null;
      _slotsEmptyHint = null;
      _slots = [];
      _selectedTime = null;
    });

    context.read<AppointmentsBloc>().add(
          LoadAvailableDaysRequested(
            patientId: patientId,
            type: type,
            month: _displayedMonth.month,
            year: _displayedMonth.year,
            treatmentSessionId: widget.treatmentSessionId,
            excludeAppointmentId: widget.rescheduleAppointmentId,
          ),
        );
  }

  void _applyAvailableDays(AvailableDaysSuccess state) {
    if (state.month != _displayedMonth.month ||
        state.year != _displayedMonth.year) {
      return;
    }

    _daysByDate
      ..clear()
      ..addEntries(state.days.map((d) => MapEntry(_dateKey(d.date), d)));

    DateTime? nextSelected;
    if (_selectedDate != null && _isBookable(_selectedDate!)) {
      nextSelected = _selectedDate;
    } else {
      final bookable = state.days.where((d) => d.isBookable).toList()
        ..sort((a, b) => a.date.compareTo(b.date));
      if (bookable.isNotEmpty) {
        nextSelected = bookable.first.date;
      }
    }

    setState(() {
      _loadingDays = false;
      _selectedDate = nextSelected;
    });

    if (nextSelected != null) {
      _loadSlots(nextSelected);
    }
  }

  void _loadSlots(DateTime day) {    if (!_usesApi) return;
    final patientId = _patientId;
    final type = widget.bookingType;
    if (patientId == null || type == null) return;

    setState(() {
      _loadingSlots = true;
      _slotsError = null;
      _slotsEmptyHint = null;
      _slots = [];
      _selectedTime = null;
    });

    context.read<AppointmentsBloc>().add(
          LoadAvailableSlotsRequested(
            patientId: patientId,
            type: type,
            date: date_fmt.formatApiDate(day),
            treatmentSessionId: widget.treatmentSessionId,
            excludeAppointmentId: widget.rescheduleAppointmentId,
          ),
        );
  }

  void _applyAvailableSlots(AvailableSlotsSuccess state) {
    if (_selectedDate == null || state.date != _dateKey(_selectedDate!)) {
      return;
    }

    setState(() {
      _loadingSlots = false;
      _slots = state.slots;
      if (state.slots.isEmpty) {
        _slotsEmptyHint = 'No available times'.tr();
      }
    });
  }

  void _goToPreviousMonth() {    if (!_canGoToPreviousMonth) return;
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
    if (_usesApi) _loadDays();
  }

  void _goToNextMonth() {
    if (!_canGoToNextMonth) return;
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
    if (_usesApi) _loadDays();
  }

  void _selectDate(DateTime day) {
    if (!_isBookable(day)) return;
    setState(() {
      _selectedDate = day;
      _selectedTime = null;
    });
    if (_usesApi) {
      _loadSlots(day);
    }
  }

  void _jumpToToday() {
    setState(() {
      _displayedMonth = DateTime(_todayDate.year, _todayDate.month);
      _selectedDate = _isBookable(_todayDate) ? _todayDate : _selectedDate;
      _selectedTime = null;
    });
    if (_usesApi) {
      _loadDays();
    }
  }

  List<DateTime?> _buildMonthGrid(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingBlanks = firstDayOfMonth.weekday - 1;
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
    final canConfirm = _selectedDate != null && _selectedTime != null;

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
              child: BlocListener<AppointmentsBloc, AppointmentsState>(
                listener: (context, state) {
                  if (state is AvailableDaysLoading) {
                    setState(() {
                      _loadingDays = true;
                      _daysError = null;
                    });
                  } else if (state is AvailableDaysSuccess) {
                    _applyAvailableDays(state);
                  } else if (state is AvailableDaysFailure) {
                    setState(() {
                      _loadingDays = false;
                      _daysByDate.clear();
                      _selectedDate = null;
                      _daysError = _mapAvailabilityError(state.errMessage);
                    });
                  } else if (state is AvailableSlotsLoading) {
                    setState(() {
                      _loadingSlots = true;
                      _slotsError = null;
                      _slotsEmptyHint = null;
                      _slots = [];
                      _selectedTime = null;
                    });
                  } else if (state is AvailableSlotsSuccess) {
                    _applyAvailableSlots(state);
                  } else if (state is AvailableSlotsFailure) {
                    setState(() {
                      _loadingSlots = false;
                      _slotsError = _mapAvailabilityError(state.errMessage);
                    });
                  }
                },
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
                                      backgroundColor:
                                          colors.primary.withOpacity(0.15),
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
                              'Select an available day, then choose a time slot.'
                                  .tr(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurface.withOpacity(0.65),
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

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
                                  if (_loadingDays)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 36,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  else if (_daysError != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 24,
                                        horizontal: 8,
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                            _daysError!,
                                            textAlign: TextAlign.center,
                                                    style: TextStyle(
                                              fontSize: 13,
                                              color: colors.error,
                                              height: 1.4,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          TextButton(
                                            onPressed: _loadDays,
                                            child: Text('Retry'.tr()),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 240,
                                      ),
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
                                        children:
                                            _buildMonthGrid(_displayedMonth)
                                                .map((day) {
                                          if (day == null) {
                                            return const SizedBox.shrink();
                                          }
                                          final selected =
                                              _selectedDate != null &&
                                              _isSameDay(day, _selectedDate!);
                                          return _DayCell(
                                            day: day,
                                            isBookable: _isBookable(day),
                                            isSelected: selected,
                                            isToday: _isSameDay(
                                              day,
                                              _todayDate,
                                            ),
                                            onTap: () => _selectDate(day),
                                          );
                                        }).toList(),
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

                          if (_selectedDate != null) ...[
                            const SizedBox(height: 16),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 200),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                child: Container(
                                  key: ValueKey<DateTime>(_selectedDate!),
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
                                            _selectedDate!,
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
                          ],

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
                            child: _buildSlotsSection(colors),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: canConfirm
                            ? () {
                                final date = _selectedDate!;
                                final time = _selectedTime!;
                                if (widget.isReschedule) {
                                  Navigator.of(context).pop(
                                    date_fmt.buildScheduledAtUtcIso(date, time),
                                  );
                                  return;
                                }
                                final appointmentsBloc =
                                    context.read<AppointmentsBloc>();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: appointmentsBloc,
                                      child: BookingConfirmationPage(
                                      visitTypeLabel:
                                            widget.visitTypeLabel ??
                                            'موعد استشارة',
                                        date: date,
                                        time: time,
                                        onConfirm: () =>
                                            _dispatchCreateAppointment(
                                          date: date,
                                          time: time,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          disabledBackgroundColor:
                              colors.primary.withOpacity(0.35),
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
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildSlotsSection(ColorScheme colors) {
    if (!_usesApi) {
      return Text(
        'Select a date first'.tr(),
        style: TextStyle(
          fontSize: 13,
          color: colors.onSurface.withOpacity(0.5),
        ),
      );
    }

    if (_selectedDate == null) {
      return Text(
        'Select a date first'.tr(),
        style: TextStyle(
          fontSize: 13,
          color: colors.onSurface.withOpacity(0.5),
        ),
      );
    }

    if (_loadingSlots) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_slotsError != null) {
      return Column(
        children: [
          Text(
            _slotsError!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: colors.error, height: 1.4),
          ),
          TextButton(
            onPressed: () => _loadSlots(_selectedDate!),
            child: Text('Retry'.tr()),
          ),
        ],
      );
    }

    if (_slots.isEmpty) {
      return Text(
        _slotsEmptyHint ?? 'No available times'.tr(),
        style: TextStyle(
          fontSize: 13.5,
          color: colors.onSurface.withOpacity(0.55),
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _slots.map((slot) {
        final isSelected = _selectedTime == slot.startTime;
        return GestureDetector(
          onTap: () => setState(() => _selectedTime = slot.startTime),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                      : colors.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 6),
                Text(
                  date_fmt.formatApiTimeLabel(slot.startTime),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? colors.primary
                        : colors.onSurface.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

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
