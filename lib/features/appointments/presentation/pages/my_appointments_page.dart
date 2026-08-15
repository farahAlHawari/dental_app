import 'package:dental_app/core/utils/patient_status_guard.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/data/models/appointment_model.dart';
import 'package:dental_app/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:dental_app/features/appointments/presentation/pages/qr_checkin_scanner_page.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_date_time_page.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_visit_type_page.dart';
import 'package:dental_app/features/appointments/presentation/widgets/appointment_card.dart';
import 'package:dental_app/features/appointments/presentation/widgets/cancel_appointment_dialog.dart';
import 'package:dental_app/features/home/presentation/pages/main_navigation_page.dart';
import 'package:dental_app/features/medical_archive/presentation/widgets/animated_tab_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// تبويب "مواعيدي" — نفس نمط فرح: Bloc + Shimmer + EmptyListState.
class MyAppointmentsPage extends StatelessWidget {
  final int refreshToken;
  final int upcomingTabToken;

  const MyAppointmentsPage({
    super.key,
    this.refreshToken = 0,
    this.upcomingTabToken = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppointmentsBloc(),
      child: _MyAppointmentsView(
        refreshToken: refreshToken,
        upcomingTabToken: upcomingTabToken,
      ),
    );
  }
}

class _MyAppointmentsView extends StatefulWidget {
  final int refreshToken;
  final int upcomingTabToken;

  const _MyAppointmentsView({
    required this.refreshToken,
    required this.upcomingTabToken,
  });

  @override
  State<_MyAppointmentsView> createState() => _MyAppointmentsViewState();
}

class _MyAppointmentsViewState extends State<_MyAppointmentsView> {
  int _tabIndex = 0;
  String? _patientId;
  List<Appointment> _upcoming = [];
  List<Appointment> _previous = [];
  bool _actionsBusy = false;
  bool _prepareDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(covariant _MyAppointmentsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.upcomingTabToken != widget.upcomingTabToken) {
      setState(() => _tabIndex = 0);
    }
    if (oldWidget.refreshToken != widget.refreshToken) {
      _load();
    }
  }

  Future<void> _load() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;

    if (patientId == null || patientId.isEmpty) {
      setState(() {
        _patientId = null;
        _upcoming = [];
        _previous = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No patient selected'.tr())),
      );
      return;
    }

    _patientId = patientId;
    if (!mounted) return;
    context.read<AppointmentsBloc>().add(
          LoadAppointmentsListRequested(patientId: patientId),
        );
  }

  Future<void> _confirmCancel(Appointment appointment) async {
    if (_actionsBusy) return;
    if (!await PatientStatusGuard.ensureSelectedPatientEditable(context)) {
      return;
    }
    if (!mounted) return;

    final reason = await CancelAppointmentDialog.show(context);
    if (reason == null || !mounted) return;

    context.read<AppointmentsBloc>().add(
          CancelAppointmentRequested(
            appointmentId: appointment.id,
            cancellationReason: reason.isEmpty ? null : reason,
          ),
        );
  }

  Future<void> _openReschedule(Appointment appointment) async {
    if (_actionsBusy) return;
    if (!await PatientStatusGuard.ensureSelectedPatientEditable(context)) {
      return;
    }
    if (!mounted) return;

    context.read<AppointmentsBloc>().add(
          PrepareRescheduleAppointmentRequested(appointment: appointment),
        );
  }

  void _showPrepareDialog() {
    if (_prepareDialogOpen || !mounted) return;
    _prepareDialogOpen = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    ).whenComplete(() => _prepareDialogOpen = false);
  }

  void _dismissPrepareDialog() {
    if (!_prepareDialogOpen || !mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> _pushRescheduleDatePicker(Appointment appointment) async {
    if (!await PatientStatusGuard.ensureSelectedPatientEditable(context)) {
      return;
    }
    if (!mounted) return;

    final appointmentsBloc = context.read<AppointmentsBloc>();
    final scheduledAt = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: appointmentsBloc,
          child: SelectDateTimePage(
            isReschedule: true,
            rescheduleAppointmentId: appointment.id,
            visitTypeLabel: appointment.visitTypeLabel,
            bookingType:
                appointment.bookingType ?? AppointmentBookingType.consultation,
            treatmentSessionId: appointment.treatmentSessionId,
          ),
        ),
      ),
    );
    if (scheduledAt == null || !mounted) return;

    context.read<AppointmentsBloc>().add(
          RescheduleAppointmentRequested(
            appointmentId: appointment.id,
            scheduledAt: scheduledAt,
          ),
        );
  }

  Future<void> _openQrCheckIn(Appointment appointment) async {
    if (_actionsBusy) return;
    if (!await PatientStatusGuard.ensureSelectedPatientEditable(context)) {
      return;
    }
    if (!mounted) return;

    final patientId = _patientId;
    if (patientId == null) return;

    final appointmentsBloc = context.read<AppointmentsBloc>();
    final checkedIn = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: appointmentsBloc,
          child: QrCheckinScannerPage(
            patientId: patientId,
            appointmentId: appointment.id,
          ),
        ),
      ),
    );
    if (checkedIn == true) {
      _load();
      MainNavigationPage.notifyDataChanged();
    }
  }

  Future<void> _openBooking() async {
    if (_actionsBusy) return;
    if (!await PatientStatusGuard.ensureSelectedPatientEditable(context)) {
      return;
    }
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectVisitTypePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final items = _tabIndex == 0 ? _upcoming : _previous;

    return Scaffold(
      appBar: AppBar(
        leading: MainNavigationPage.homeTabBackButton(context),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton.extended(
          onPressed: _actionsBusy ? null : _openBooking,
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: Text(
            'Book New Appointment'.tr(),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              child: BlocConsumer<AppointmentsBloc, AppointmentsState>(
                listener: (context, state) {
                  if (state is AppointmentsListSuccess) {
                    setState(() {
                      _upcoming = List.from(state.upcoming);
                      _previous = List.from(state.previous);
                      _actionsBusy = false;
                    });
                    if (state.warningMessage != null &&
                        state.warningMessage!.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.warningMessage!)),
                      );
                    }
                  } else if (state is AppointmentsListFailure) {
                    setState(() {
                      _upcoming = [];
                      _previous = [];
                      _actionsBusy = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  } else if (state is CancelAppointmentLoading ||
                      state is RescheduleAppointmentLoading) {
                    setState(() => _actionsBusy = true);
                  } else if (state is CancelAppointmentSuccess) {
                    setState(() => _actionsBusy = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Appointment cancelled'.tr())),
                    );
                    MainNavigationPage.notifyDataChanged();
                    _load();
                  } else if (state is CancelAppointmentFailure) {
                    setState(() => _actionsBusy = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  } else if (state is ReschedulePrepareLoading) {
                    setState(() => _actionsBusy = true);
                    _showPrepareDialog();
                  } else if (state is ReschedulePreparedSuccess) {
                    _dismissPrepareDialog();
                    setState(() => _actionsBusy = false);
                    _pushRescheduleDatePicker(state.appointment);
                  } else if (state is ReschedulePreparedFailure) {
                    _dismissPrepareDialog();
                    setState(() => _actionsBusy = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  } else if (state is RescheduleAppointmentSuccess) {
                    setState(() => _actionsBusy = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Appointment rescheduled'.tr())),
                    );
                    MainNavigationPage.notifyDataChanged();
                    _load();
                  } else if (state is RescheduleAppointmentFailure) {
                    setState(() => _actionsBusy = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    current is AppointmentsListLoading ||
                    current is AppointmentsListSuccess ||
                    current is AppointmentsListFailure ||
                    current is AppointmentsInitial ||
                    current is CancelAppointmentLoading ||
                    current is CancelAppointmentSuccess ||
                    current is CancelAppointmentFailure ||
                    current is RescheduleAppointmentLoading ||
                    current is RescheduleAppointmentSuccess ||
                    current is RescheduleAppointmentFailure ||
                    current is ReschedulePrepareLoading ||
                    current is ReschedulePreparedSuccess ||
                    current is ReschedulePreparedFailure,
                builder: (context, state) {
                  final loading = state is AppointmentsListLoading ||
                      (state is AppointmentsInitial &&
                          _upcoming.isEmpty &&
                          _previous.isEmpty);

                  if (loading) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                          child: AnimatedTabBar(
                            tabs: ['Upcoming'.tr(), 'Previous'.tr()],
                            selectedIndex: _tabIndex,
                            onChanged: (index) =>
                                setState(() => _tabIndex = index),
                          ),
                        ),
                        const Expanded(child: AppointmentsListShimmer()),
                      ],
                    );
                  }

                  if (state is AppointmentsListFailure &&
                      _upcoming.isEmpty &&
                      _previous.isEmpty) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                          child: AnimatedTabBar(
                            tabs: ['Upcoming'.tr(), 'Previous'.tr()],
                            selectedIndex: _tabIndex,
                            onChanged: (index) =>
                                setState(() => _tabIndex = index),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    state.errMessage,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _load,
                                    child: Text('Retry'.tr()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: AnimatedTabBar(
                          tabs: ['Upcoming'.tr(), 'Previous'.tr()],
                          selectedIndex: _tabIndex,
                          onChanged: (index) =>
                              setState(() => _tabIndex = index),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _load,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                            child: items.isEmpty
                                ? ListView(
                                    key: ValueKey('empty_$_tabIndex'),
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.22,
                                      ),
                                      EmptyListState(
                                        message: (_tabIndex == 0
                                                ? 'No upcoming appointments'
                                                : 'No previous visits yet')
                                            .tr(),
                                        animationSize: 140,
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    key: ValueKey('list_$_tabIndex'),
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      10,
                                      16,
                                      90,
                                    ),
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      final appointment = items[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 14),
                                        child: FadeSlideIn(
                                          delay: Duration(
                                              milliseconds: 60 * index),
                                          child: AppointmentCard(
                                            appointment: appointment,
                                            actionsEnabled: !_actionsBusy,
                                            onCancel: () =>
                                                _confirmCancel(appointment),
                                            onReschedule: () =>
                                                _openReschedule(appointment),
                                            onScanQr: () =>
                                                _openQrCheckIn(appointment),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
