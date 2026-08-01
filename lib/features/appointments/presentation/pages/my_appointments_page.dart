import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dental_app/core/widgets/dialog.dart';
import 'package:dental_app/features/appointments/data/mock_appointments_data.dart';
import 'package:dental_app/features/appointments/data/models/appointment_model.dart';
import 'package:dental_app/features/appointments/data/models/appointment_status.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_date_time_page.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_visit_type_page.dart';
import 'package:dental_app/features/appointments/presentation/widgets/appointment_card.dart';
import 'package:dental_app/features/medical_archive/presentation/widgets/animated_tab_bar.dart';

/// تبويب "مواعيدي" - تابين: القادمة (pending/confirmed/checked-in/in-treatment)
/// والسابقة (completed/cancelled/no-show). البيانات mock محلياً حالياً - نفس
/// نمط باقي تبويبات التطبيق لحد ما يتوفر الـ backend.
class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  late List<Appointment> _appointments = buildMockAppointments();
  int _tabIndex = 0;

  List<Appointment> get _upcoming {
    final list = _appointments.where((a) => a.status.isUpcoming).toList();
    list.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return list;
  }

  List<Appointment> get _previous {
    final list = _appointments.where((a) => !a.status.isUpcoming).toList();
    list.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    return list;
  }

  void _updateAppointment(Appointment updated) {
    setState(() {
      _appointments = _appointments
          .map((a) => a.id == updated.id ? updated : a)
          .toList();
    });
  }

  void _confirmCancel(Appointment appointment) {
    CustomStatusDialog.show(
      context,
      title: 'Cancel this appointment?'.tr(),
      description:
          'Are you sure you want to cancel this appointment? This action cannot be undone.'
              .tr(),
      confirmButtonText: 'Yes, Cancel'.tr(),
      cancelButtonText: 'Keep Appointment'.tr(),
      onConfirm: () {
        Navigator.pop(context);
        _updateAppointment(
          appointment.copyWith(status: AppointmentStatus.cancelled),
        );
      },
    );
  }

  void _openReschedule(Appointment appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDateTimePage(
          isReschedule: true,
          onDateTimeSelected: (date, time) {
            final timeParts = _parseTimeOfDay(time);
            final newDate = DateTime(
              date.year,
              date.month,
              date.day,
              timeParts.hour,
              timeParts.minute,
            );
            // تغيير الموعد بيحدّث الوقت بس، وبيحافظ على نفس الحالة الحالية
            // (لو كان "قيد الانتظار" بضل "قيد الانتظار"، ولو كان "مؤكد"
            // بضل "مؤكد") - إعادة الجدولة ما بتغيّر حالة التأكيد نفسها.
            _updateAppointment(appointment.copyWith(scheduledAt: newDate));
          },
        ),
      ),
    );
  }

  ({int hour, int minute}) _parseTimeOfDay(String label) {
    // متوقع شكل "9:00 AM" / "1:00 PM" - نفس الشكل يلي بيولده SelectDateTimePage.
    final isPm = label.toUpperCase().contains('PM');
    final digitsPart = label.replaceAll(RegExp(r'[^0-9:]'), '');
    final parts = digitsPart.split(':');
    var hour = int.tryParse(parts.first) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    if (isPm && hour != 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;
    return (hour: hour, minute: minute);
  }

  void _openBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectVisitTypePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final items = _tabIndex == 0 ? _upcoming : _previous;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Appointments'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
      ),
      backgroundColor: colors.surfaceContainerHighest,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/background3.png',
                fit: BoxFit.cover,
                color: colors.primary,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: AnimatedTabBar(
                      tabs: ['Upcoming'.tr(), 'Previous'.tr()],
                      selectedIndex: _tabIndex,
                      onChanged: (index) => setState(() => _tabIndex = index),
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: items.isEmpty
                          ? _EmptyState(
                              key: ValueKey('empty_$_tabIndex'),
                              isUpcoming: _tabIndex == 0,
                            )
                          : ListView.builder(
                              key: ValueKey('list_$_tabIndex'),
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                10,
                                16,
                                110,
                              ),
                              itemCount:
                                  items.length + (_tabIndex == 0 ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (_tabIndex == 0 && index == items.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: _BookAppointmentButton(
                                      onTap: _openBooking,
                                    ),
                                  );
                                }

                                final appointment = items[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: AppointmentCard(
                                    appointment: appointment,
                                    onCancel: () => _confirmCancel(appointment),
                                    onReschedule: () =>
                                        _openReschedule(appointment),
                                  ),
                                );
                              },
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

class _EmptyState extends StatelessWidget {
  final bool isUpcoming;

  const _EmptyState({super.key, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 56,
              color: colors.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 14),
            Text(
              (isUpcoming
                      ? 'No upcoming appointments'
                      : 'No previous visits yet')
                  .tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// زر حجز موعد جديد - يظهر بس بنص الواجهة بعد آخر كرت بتبويب "القادمة".
class _BookAppointmentButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BookAppointmentButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
        label: Text(
          'Book New Appointment'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
