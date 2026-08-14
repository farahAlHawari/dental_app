import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/services/whatsapp_service.dart';
import 'package:dental_app/core/utils/clinic_contact.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/core/widgets/patient_avatar.dart';
import 'package:dental_app/features/appointments/data/models/appointment_model.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:dental_app/features/chatbot/presentation/pages/chatbot_page.dart';
import 'package:dental_app/features/appointments/presentation/pages/qr_checkin_scanner_page.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_visit_type_page.dart';
import 'package:dental_app/features/appointments/presentation/utils/appointment_date_format.dart';
import 'package:dental_app/features/archived_visits/domain/session_rating_helper.dart';
import 'package:dental_app/features/archived_visits/presentation/bloc/archived_visits_bloc.dart';
import 'package:dental_app/features/archived_visits/presentation/widgets/ratingDialog.dart';
import 'package:dental_app/features/financial_and_billing/presentation/pages/financial_page.dart';
import 'package:dental_app/features/home/presentation/widgets/active_treatment_plan_card.dart';
import 'package:dental_app/features/home/presentation/widgets/animated_notification_icon.dart';
import 'package:dental_app/features/home/presentation/widgets/assistant_hero_card.dart';
import 'package:dental_app/features/home/presentation/widgets/daily_tip_card.dart';
import 'package:dental_app/features/home/presentation/widgets/quick_action_card.dart';
import 'package:dental_app/features/home/presentation/widgets/upcoming_appointment_card.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/medical_archive_page.dart';
import 'package:dental_app/features/profile/data/datasources/patient_remote_data_source.dart';
import 'package:dental_app/features/profile/domain/repositories/patient_repository_impl.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan.dart';
import 'package:dental_app/features/treatment_plans/presentation/bloc/treatment_plans_bloc.dart';
import 'package:dental_app/features/treatment_plans/presentation/pages/treatment_plan_details_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// تبويب "الرئيسية".
/// Uses ArchivedVisitsBloc for GET /home + pending rating.
/// Patient name/photo from GET patients/:id.
class HomePage extends StatelessWidget {
  /// بيزيد وحدة كل مرة يصير فيها دخول للتاب هاد (من MainNavigationPage) -
  /// منستخدمها كـ key لكارد الخطة العلاجية حتى يعيد تشغيل أنيميشن شريط
  /// التقدم من الصفر كل مرة نرجع عالرئيسية، مش مرة وحدة بس.
  final int homeVisitCount;

  const HomePage({super.key, required this.homeVisitCount});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ArchivedVisitsBloc()),
        BlocProvider(create: (_) => AppointmentsBloc()),
        BlocProvider(create: (_) => TreatmentPlansBloc()),
      ],
      child: _HomePageView(homeVisitCount: homeVisitCount),
    );
  }
}

class _HomePageView extends StatefulWidget {
  final int homeVisitCount;

  const _HomePageView({required this.homeVisitCount});

  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  final _patientRepository = PatientRepositoryImpl(
    remoteDataSource: PatientRemoteDataSource(api: DioConsumer(dio: Dio())),
  );

  bool _dialogOpen = false;
  String? _patientId;
  Map<String, dynamic>? _patient;
  bool _patientProfileLoading = true;
  Appointment? _upcomingAppointment;
  bool _upcomingLoaded = false;
  TreatmentPlan? _activePlan;
  bool _activePlanLoaded = false;

  String get _patientDisplayName {
    final name = (_patient?['fullName'] ?? _patient?['name'] ?? '').toString();
    return name.trim().isEmpty ? '—' : name.trim();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestHome();
      _loadPatientProfile();
      _loadUpcoming();
      _loadActivePlan();
    });
  }

  @override
  void didUpdateWidget(covariant _HomePageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.homeVisitCount != widget.homeVisitCount) {
      _requestHome();
      _loadPatientProfile();
      _loadUpcoming();
      _loadActivePlan();
    }
  }

  Future<void> _loadPatientProfile() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;
    if (patientId == null || patientId.isEmpty) {
      setState(() {
        _patient = null;
        _patientProfileLoading = false;
      });
      return;
    }

    setState(() => _patientProfileLoading = true);
    final result = await _patientRepository.getPatientById(patientId);
    if (!mounted) return;
    result.fold(
      (_) {
        setState(() {
          _patient = null;
          _patientProfileLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to load patient profile'.tr())),
        );
      },
      (data) => setState(() {
        _patient = data;
        _patientProfileLoading = false;
      }),
    );
  }

  Future<void> _loadUpcoming() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;
    if (patientId == null || patientId.isEmpty) {
      setState(() {
        _upcomingAppointment = null;
        _upcomingLoaded = true;
      });
      return;
    }

    setState(() => _upcomingLoaded = false);
    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<AppointmentsBloc>().add(
          LoadUpcomingAppointmentRequested(patientId: patientId),
        );
  }

  Future<void> _loadActivePlan() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;
    if (patientId == null || patientId.isEmpty) {
      setState(() {
        _activePlan = null;
        _activePlanLoaded = true;
      });
      return;
    }

    setState(() => _activePlanLoaded = false);
    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<TreatmentPlansBloc>().add(
          LoadActiveTreatmentPlansRequested(patientId: patientId),
        );
  }

  Future<void> _openActivePlanDetails() async {
    final plan = _activePlan;
    if (plan == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => TreatmentPlansBloc(),
          child: TreatmentPlanDetailsPage(planId: plan.id),
        ),
      ),
    );
    if (mounted) await _loadActivePlan();
  }

  Future<void> _requestHome() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;
    if (patientId == null || patientId.isEmpty) return;

    _patientId = patientId;
    context.read<ArchivedVisitsBloc>().add(
          LoadPatientHomeRequested(patientId: patientId),
        );
  }

  Future<void> _handlePatientHome(PatientHomeSuccess state) async {
    if (_dialogOpen || !mounted) return;

    final pending = state.data['pendingRating'];
    if (pending is! Map) return;
    final pendingMap = Map<String, dynamic>.from(pending);
    if (!SessionRatingHelper.homePendingCanRate(pendingMap)) return;

    final session = pendingMap['session'];
    final sessionMap =
        session is Map ? Map<String, dynamic>.from(session) : null;
    final title = (sessionMap?['title'] ?? 'Session'.tr()).toString();
    final sessionId =
        (pendingMap['treatmentSessionId'] ?? sessionMap?['id'] ?? '')
            .toString();
    if (sessionId.isEmpty) return;

    _dialogOpen = true;
    final selected = await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (_) => RatingDialog(sessionTitle: title),
    );
    _dialogOpen = false;
    if (selected == null || selected < 1 || !mounted) return;

    final patientId = _patientId;
    if (patientId == null) return;

    context.read<ArchivedVisitsBloc>().add(
          RateSessionRequested(
            patientId: patientId,
            sessionId: sessionId,
            rating: selected,
          ),
        );
  }

  Future<void> _openQrCheckIn() async {
    final patientId = _patientId ?? await SharedPrefs.getSelectedPatientId();
    final upcoming = _upcomingAppointment;
    if (!mounted) return;
    if (patientId == null || upcoming == null) return;

    final appointmentsBloc = context.read<AppointmentsBloc>();
    final checkedIn = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: appointmentsBloc,
          child: QrCheckinScannerPage(
            patientId: patientId,
            appointmentId: upcoming.id,
          ),
        ),
      ),
    );
    if (checkedIn == true) {
      _loadUpcoming();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<ArchivedVisitsBloc, ArchivedVisitsState>(
          listener: (context, state) {
            if (state is PatientHomeSuccess) {
              _handlePatientHome(state);
            } else if (state is PatientHomeFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errMessage)),
              );
            } else if (state is RateSessionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Thank you for your rating'.tr())),
              );
            } else if (state is RateSessionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errMessage)),
              );
            }
          },
        ),
        BlocListener<AppointmentsBloc, AppointmentsState>(
          listener: (context, state) {
            if (state is UpcomingAppointmentSuccess) {
              setState(() {
                _upcomingAppointment = state.appointment;
                _upcomingLoaded = true;
              });
            } else if (state is UpcomingAppointmentFailure) {
              setState(() {
                _upcomingAppointment = null;
                _upcomingLoaded = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errMessage)),
              );
            }
          },
        ),
        BlocListener<TreatmentPlansBloc, TreatmentPlansState>(
          listener: (context, state) {
            if (state is TreatmentPlansListSuccess) {
              setState(() {
                _activePlan = TreatmentPlan.newestByCreatedAt(state.active);
                _activePlanLoaded = true;
              });
            } else if (state is TreatmentPlansListFailure) {
              setState(() {
                _activePlan = null;
                _activePlanLoaded = true;
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: colors.surfaceContainerHighest,
        body: SizedBox.expand(
          child: Stack(
            children: [
              SafeArea(
                child: RefreshIndicator(
                  color: colors.primary,
                  onRefresh: () async {
                    await Future.wait([
                      _requestHome(),
                      _loadPatientProfile(),
                      _loadUpcoming(),
                      _loadActivePlan(),
                    ]);
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: colors.surface,
                      elevation: 0,
                      scrolledUnderElevation: 4,
                      shadowColor: colors.shadow,
                      automaticallyImplyLeading: false,
                      toolbarHeight: 68,
                      titleSpacing: 0,
                      title: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FadeSlideIn(
                          child: Row(
                            children: [
                              _patientProfileLoading
                                  ? AppShimmer(
                                      child: ShimmerBox(
                                        width: 44,
                                        height: 44,
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                    )
                                  : PatientAvatar.fromPatient(
                                      _patient,
                                      radius: 22,
                                      backgroundColor:
                                          colors.primary.withOpacity(0.12),
                                      iconColor: colors.primary,
                                    ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Welcome'.tr(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: colors.onSurface
                                            .withOpacity(0.55),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    _patientProfileLoading
                                        ? AppShimmer(
                                            child: ShimmerBox(
                                              width: 120,
                                              height: 16,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          )
                                        : Text(
                                            _patientDisplayName,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: colors.onSurface,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: colors.onSurface.withOpacity(0.06),
                                  shape: BoxShape.circle,
                                ),
                                child: AnimatedNotificationIcon(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Notifications coming soon'.tr(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 72),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          BlocBuilder<AppointmentsBloc, AppointmentsState>(
                            buildWhen: (previous, current) =>
                                current is UpcomingAppointmentLoading ||
                                current is UpcomingAppointmentSuccess ||
                                current is UpcomingAppointmentFailure ||
                                current is AppointmentsInitial,
                            builder: (context, upcomingState) {
                              final loadingUpcoming =
                                  ! _upcomingLoaded ||
                                  upcomingState is UpcomingAppointmentLoading;

                              if (loadingUpcoming) {
                                return Column(
                                  key: const ValueKey('upcoming_loading'),
                                  children: [
                                    FadeSlideIn(
                                      delay:
                                          const Duration(milliseconds: 60),
                                      child:
                                          const UpcomingAppointmentCardShimmer(),
                                    ),
                                    const SizedBox(height: 16),
                                    FadeSlideIn(
                                      delay:
                                          const Duration(milliseconds: 100),
                                      child: const DailyTipCard(),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              }

                              if (_upcomingAppointment != null) {
                                final upcoming = _upcomingAppointment!;
                                return Column(
                                  key: const ValueKey('upcoming_card'),
                                  children: [
                                    FadeSlideIn(
                                      delay:
                                          const Duration(milliseconds: 60),
                                      child: UpcomingAppointmentCard(
                                        treatmentName: upcoming.visitTypeLabel,
                                        appointmentDate: upcoming.scheduledAt,
                                        timeLabel: formatAppointmentTime(
                                          upcoming.scheduledAt,
                                        ),
                                        status: upcoming.status,
                                        onScanQr: _openQrCheckIn,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    FadeSlideIn(
                                      delay:
                                          const Duration(milliseconds: 100),
                                      child: const DailyTipCard(),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              }

                              return Column(
                                key: const ValueKey('no_upcoming'),
                                children: [
                                  FadeSlideIn(
                                    delay: const Duration(milliseconds: 60),
                                    child: const DailyTipCard(),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            },
                          ),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 140),
                            child: AssistantHeroCard(
                              onStartChat: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ChatbotPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (!_activePlanLoaded)
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 180),
                              child: const TreatmentPlanCardShimmer(),
                            )
                          else if (_activePlan != null)
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 180),
                              child: ActiveTreatmentPlanCard(
                                key: ValueKey(
                                  'treatment_plan_${_activePlan!.id}_${widget.homeVisitCount}',
                                ),
                                planName: _activePlan!.name.isEmpty
                                    ? 'Treatment plan'.tr()
                                    : _activePlan!.name,
                                currentSession: _activePlan!.currentSession,
                                totalSessions: _activePlan!.sessionCount,
                                progress: _activePlan!.progress,
                                onViewDetails: _openActivePlanDetails,
                              ),
                            ),
                          if (!_activePlanLoaded || _activePlan != null)
                            const SizedBox(height: 16),
                          const SizedBox(height: 4),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 240),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 4, bottom: 12),
                              child: Text(
                                'Quick Actions'.tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurface,
                                ),
                              ),
                            ),
                          ),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 280),
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.92,
                              children: [
                                QuickActionCard(
                                  icon: Icons.description_outlined,
                                  label: 'My Medical Record'.tr(),
                                  subtitle: 'View files & history'.tr(),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MedicalArchivePage(),
                                      ),
                                    );
                                  },
                                ),
                                QuickActionCard(
                                  icon: Icons.calendar_month_outlined,
                                  label: 'Book Appointment'.tr(),
                                  subtitle: 'Pick a date & time'.tr(),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SelectVisitTypePage(),
                                      ),
                                    );
                                  },
                                ),
                                QuickActionCard(
                                  icon: Icons.warning_amber_rounded,
                                  label: 'Emergency Appointment'.tr(),
                                  subtitle: 'Get urgent care now'.tr(),
                                  isDanger: true,
                                  onTap: () async {
                                    try {
                                      await WhatsAppService.openWhatsApp(
                                        phone: ClinicContact.whatsAppNumber,
                                        message:
                                            'Hello, I need an emergency dental appointment. Please contact me as soon as possible.'
                                                .tr(),
                                      );
                                    } catch (_) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please contact the clinic immediately for urgent care.'
                                                .tr(),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                QuickActionCard(
                                  icon: Icons.receipt_long_outlined,
                                  label: 'Invoices'.tr(),
                                  subtitle: 'Check your bills'.tr(),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FinancialPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]),
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
