import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/appointments/data/models/appointment_status.dart';
import 'package:dental_app/features/appointments/presentation/pages/chatbot_page.dart';
import 'package:dental_app/features/appointments/presentation/pages/qr_checkin_scanner_page.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_visit_type_page.dart';
import 'package:dental_app/features/financial_and_billing/presentation/pages/financial_page.dart';
import 'package:dental_app/features/home/presentation/widgets/active_treatment_plan_card.dart';
import 'package:dental_app/features/home/presentation/widgets/animated_notification_icon.dart';
import 'package:dental_app/features/home/presentation/widgets/assistant_hero_card.dart';
import 'package:dental_app/features/home/presentation/widgets/daily_tip_card.dart';
import 'package:dental_app/features/home/presentation/widgets/quick_action_card.dart';
import 'package:dental_app/features/appointments/presentation/utils/appointment_date_format.dart';
import 'package:dental_app/features/home/presentation/widgets/upcoming_appointment_card.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/medical_archive_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// تبويب "الرئيسية". كل البيانات هون تجريبية (TODO عالمكان المناسب
/// لما يوصل الـ backend).
class HomePage extends StatefulWidget {
  /// بيزيد وحدة كل مرة يصير فيها دخول للتاب هاد (من MainNavigationPage) -
  /// منستخدمها كـ key لكارد الخطة العلاجية حتى يعيد تشغيل أنيميشن شريط
  /// التقدم من الصفر كل مرة نرجع عالرئيسية، مش مرة وحدة بس.
  final int homeVisitCount;

  const HomePage({super.key, required this.homeVisitCount});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO: بدّلها بحالة الموعد القادم الفعلية من الـ backend.
  AppointmentStatus _upcomingStatus = AppointmentStatus.confirmed;

  // TODO: بدّلها بمعرفة وجود موعد قادم فعلي من الـ backend - بتتحكم
  // بمكان ظهور كارد "نصيحة يومية" (أول عنصر إذا مفيش موعد قادم).
  final bool _hasUpcomingAppointment = true;

  // TODO: بدّليه باسم المريض الفعلي من الـ backend لما يجهز - اسم علم
  // بضل عربي بغض النظر عن اللغة، نفس فكرة اسم الطبيب بالمواعيد التجريبية.
  static const String _patientName = 'سارة خالد';

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

    return Scaffold(
      backgroundColor: colors.surfaceContainerHighest,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Positioned.fill(
            //   child: Image.asset(
            //     'assets/backgrounds/background3.png',
            //     fit: BoxFit.cover,
            //     color: Theme.of(context).colorScheme.primary,
            //   ),
            // ),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  // هيدر ثابت (pinned) - ما بيروح مع السكرول متل قبل.
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
                                      color: colors.onSurface.withOpacity(0.55),
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
                                // TODO: نقل لشاشة الإشعارات لما تجهز (قسم فرح، FR-P-13).
                                onTap: () {},
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
                            padding: const EdgeInsets.only(left: 4, bottom: 12),
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
    );
  }
}
