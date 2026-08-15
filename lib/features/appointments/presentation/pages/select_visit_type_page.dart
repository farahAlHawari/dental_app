import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/utils/patient_status_guard.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/custom_confirmation_dialog.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:dental_app/features/appointments/presentation/pages/consultation_reason_page.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_follow_up_session_page.dart';
import 'package:dental_app/features/appointments/presentation/widgets/visit_type_card.dart';
import 'package:dental_app/features/home/presentation/pages/main_navigation_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectVisitTypePage extends StatelessWidget {
  const SelectVisitTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppointmentsBloc(),
      child: const _SelectVisitTypeView(),
    );
  }
}

class _SelectVisitTypeView extends StatefulWidget {
  const _SelectVisitTypeView();

  @override
  State<_SelectVisitTypeView> createState() => _SelectVisitTypeViewState();
}

class _SelectVisitTypeViewState extends State<_SelectVisitTypeView> {
  bool _consultationBlocked = false;
  bool _gateLoading = true;
  bool _gateReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadGate());
  }

  Future<void> _loadGate() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;
    if (patientId == null || patientId.isEmpty) {
      setState(() {
        _gateLoading = false;
        _gateReady = true;
        _consultationBlocked = false;
      });
      return;
    }

    context.read<AppointmentsBloc>().add(
          LoadActiveConsultationGateRequested(patientId: patientId),
        );
  }

  Future<void> _openConsultation() async {
    if (!await PatientStatusGuard.ensureSelectedPatientEditable(context)) {
      return;
    }
    if (!mounted) return;

    if (_gateLoading || !_gateReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checking...'.tr())),
      );
      return;
    }

    if (_consultationBlocked) {
      CustomConfirmationDialog.show(
        context,
        title: 'Cannot book consultation'.tr(),
        description:
            'You already have an active consultation appointment. Please cancel or reschedule it from My Appointments before booking a new one.'
                .tr(),
        confirmButtonText: 'View my appointments'.tr(),
        cancelButtonText: 'OK'.tr(),
        isDestructive: true,
        onCancel: () => Navigator.of(context).pop(),
        onConfirm: () {
          Navigator.of(context).pop();
          _goToMyAppointments();
        },
      );
      return;
    }

    final appointmentsBloc = context.read<AppointmentsBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: appointmentsBloc,
          child: ConsultationReasonPage(
            visitTypeLabel: 'Initial Consultation / First Visit'.tr(),
          ),
        ),
      ),
    );
  }

  Future<void> _openFollowUp() async {
    if (!await PatientStatusGuard.ensureSelectedPatientEditable(context)) {
      return;
    }
    if (!mounted) return;

    final appointmentsBloc = context.read<AppointmentsBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: appointmentsBloc,
          child: const SelectFollowUpSessionPage(),
        ),
      ),
    );
  }

  void _goToMyAppointments() {
    Navigator.of(context).popUntil(
      (route) =>
          route.settings.name == MainNavigationPage.routeName || route.isFirst,
    );
    MainNavigationPage.goToAppointmentsTab();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocListener<AppointmentsBloc, AppointmentsState>(
      listener: (context, state) {
        if (state is ActiveConsultationGateLoading) {
          setState(() {
            _gateLoading = true;
            _gateReady = false;
          });
        } else if (state is ActiveConsultationGateReady) {
          setState(() {
            _gateLoading = false;
            _gateReady = true;
            _consultationBlocked = state.consultationBlocked;
          });
        } else if (state is ActiveConsultationGateFailure) {
          setState(() {
            _gateLoading = false;
            _gateReady = true;
            // Fail open visually; backend still enforces the rule.
            _consultationBlocked = false;
          });
        }
      },
      child: Scaffold(
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
                  color: colors.primary,
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Visit Type'.tr(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurface.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Step 1 of 3'.tr(),
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
                          tween: Tween(begin: 0, end: 1 / 3),
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) => LinearProgressIndicator(
                            value: value,
                            minHeight: 6,
                            backgroundColor: colors.primary.withOpacity(0.15),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      FadeSlideIn(
                        child: Text(
                          'How can we help you today?'.tr(),
                          textAlign: TextAlign.start,
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
                          'Choose the appointment type that suits your condition to start booking.'
                              .tr(),
                          textAlign: TextAlign.start,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurface.withOpacity(0.65),
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 140),
                        child: VisitTypeCard(
                          title: 'Initial Consultation / First Visit'.tr(),
                          subtitle:
                              'For new patients or to discuss a new health concern. Includes a full exam and opening a medical file.'
                                  .tr(),
                          actionText: 'Start treatment journey'.tr(),
                          icon: Icons.person_outline_rounded,
                          accentColor: AppColors.primary,
                          onTap: _openConsultation,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 220),
                        child: VisitTypeCard(
                          title:
                              'Follow-up within an existing treatment plan'.tr(),
                          subtitle:
                              'For registered patients to complete treatment sessions or scheduled periodic check-ups.'
                                  .tr(),
                          actionText: 'Continue current plan'.tr(),
                          icon: Icons.assignment_outlined,
                          accentColor: AppColors.primary,
                          onTap: _openFollowUp,
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
    );
  }
}
