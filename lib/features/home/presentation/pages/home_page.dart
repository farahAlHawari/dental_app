import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/appointments/data/models/appointment_status.dart';
import 'package:dental_app/features/appointments/presentation/pages/chatbot_page.dart';
import 'package:dental_app/features/appointments/presentation/pages/qr_checkin_scanner_page.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_visit_type_page.dart';
import 'package:dental_app/features/appointments/presentation/utils/appointment_date_format.dart';
import 'package:dental_app/features/archived_visits/domain/session_rating_helper.dart';
import 'package:dental_app/features/archived_visits/presentation/bloc/archived_visits_bloc.dart';
import 'package:dental_app/features/archived_visits/presentation/widgets/ratingDialog.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/features/financial_and_billing/presentation/pages/financial_page.dart';
import 'package:dental_app/features/home/presentation/widgets/active_treatment_plan_card.dart';
import 'package:dental_app/features/home/presentation/widgets/animated_notification_icon.dart';
import 'package:dental_app/features/home/presentation/widgets/assistant_hero_card.dart';
import 'package:dental_app/features/home/presentation/widgets/daily_tip_card.dart';
import 'package:dental_app/features/home/presentation/widgets/quick_action_card.dart';
import 'package:dental_app/features/home/presentation/widgets/upcoming_appointment_card.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/medical_archive_page.dart';
import 'package:dental_app/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:dental_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:dental_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// تبويب "الرئيسية". كل البيانات هون تجريبية (TODO عالمكان المناسب
/// لما يوصل الـ backend).
/// Uses ArchivedVisitsBloc for GET /home + pending rating.
class HomePage extends StatelessWidget {
  /// بيزيد وحدة كل مرة يصير فيها دخول للتاب هاد (من MainNavigationPage) -
  /// منستخدمها كـ key لكارد الخطة العلاجية حتى يعيد تشغيل أنيميشن شريط
  /// التقدم من الصفر كل مرة نرجع عالرئيسية، مش مرة وحدة بس.
  final int homeVisitCount;

  /// يزيد من MainNavigationPage عند أول دخول وعند app resume — لفحص التقييم فقط.
  final int ratingCheckTick;

  const HomePage({
    super.key,
    required this.homeVisitCount,
    required this.ratingCheckTick,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArchivedVisitsBloc(),
      child: _HomePageView(
        homeVisitCount: homeVisitCount,
        ratingCheckTick: ratingCheckTick,
      ),
    );
  }
}

class _HomePageView extends StatefulWidget {
  final int homeVisitCount;
  final int ratingCheckTick;

  const _HomePageView({
    required this.homeVisitCount,
    required this.ratingCheckTick,
  });

  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  bool _dialogOpen = false;
  String? _pendingSessionId;
  String? _patientId;
  int _unreadNotifications = 0;

  // TODO: بدّلها بحالة الموعد القادم الفعلية من الـ backend.
  AppointmentStatus _upcomingStatus = AppointmentStatus.confirmed;

  // TODO: بدّلها بمعرفة وجود موعد قادم فعلي من الـ backend - بتتحكم
  // بمكان ظهور كارد "نصيحة يومية" (أول عنصر إذا مفيش موعد قادم).
  final bool _hasUpcomingAppointment = true;

  // TODO: بدّليه باسم المريض الفعلي من الـ backend لما يجهز - اسم علم
  // بضل عربي بغض النظر عن اللغة، نفس فكرة اسم الطبيب بالمواعيد التجريبية.
  static const String _patientName = 'سارة خالد';

  final _notificationsRepository = NotificationsRepository(
    remoteDataSource: NotificationsRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPendingRating();
      _loadUnreadCount();
    });
  }

  @override
  void didUpdateWidget(covariant _HomePageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ratingCheckTick != widget.ratingCheckTick) {
      _checkPendingRating();
      _loadUnreadCount();
    }
  }

  Future<void> _loadUnreadCount() async {
    final result = await _notificationsRepository.getUnreadCount();
    if (!mounted) return;
    result.fold(
      (_) {},
      (count) => setState(() => _unreadNotifications = count),
    );
  }

  Future<void> _openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsPage()),
    );
    if (!mounted) return;
    await _loadUnreadCount();
  }

  Future<void> _checkPendingRating() async {
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

    _pendingSessionId = sessionId;
    context.read<ArchivedVisitsBloc>().add(
          RateSessionRequested(
            patientId: patientId,
            sessionId: sessionId,
            rating: selected,
          ),
        );
  }

  Future<void> _openQrCheckIn() async {
    final checkedIn = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const QrCheckinScannerPage()),
    );
    if (checkedIn == true) {
      setState(() => _upcomingStatus = AppointmentStatus.checkedIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocListener<ArchivedVisitsBloc, ArchivedVisitsState>(
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
          _pendingSessionId = null;
        } else if (state is RateSessionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMessage)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colors.surfaceContainerHighest,
        body: SizedBox.expand(
          child: Stack(
            children: [
              SafeArea(
                child: CustomScrollView(
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
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: colors.primary.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person_rounded,
                                  color: colors.primary,
                                  size: 24,
                                ),
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
                                    Text(
                                      _patientName,
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
                                  unreadCount: _unreadNotifications,
                                  onTap: _openNotifications,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          if (_hasUpcomingAppointment) ...[
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 60),
                              child: UpcomingAppointmentCard(
                                treatmentName: 'Teeth Cleaning'.tr(),
                                // TODO: بدّليها بتاريخ الموعد الحقيقي.
                                appointmentDate: DateTime.now().add(
                                  const Duration(days: 3),
                                ),
                                timeLabel: formatMockTimeLabel('02:00 PM'),
                                status: _upcomingStatus,
                                onScanQr: _openQrCheckIn,
                              ),
                            ),
                            const SizedBox(height: 16),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 100),
                              child: const DailyTipCard(),
                            ),
                            const SizedBox(height: 16),
                          ] else ...[
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 60),
                              child: const DailyTipCard(),
                            ),
                            const SizedBox(height: 16),
                          ],
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
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 180),
                            child: ActiveTreatmentPlanCard(
                              key: ValueKey(
                                'treatment_plan_${widget.homeVisitCount}',
                              ),
                              planName: 'Metal Braces'.tr(),
                              currentSession: 2,
                              totalSessions: 5,
                              progress: 0.4,
                              onViewDetails: () {
                                // TODO: navigate to treatment plan details page.
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
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
                              childAspectRatio: 1.05,
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
                                  onTap: () {
                                    // TODO: navigate to emergency contact flow.
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
            ],
          ),
        ),
      ),
    );
  }
}
