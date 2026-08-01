import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_visit_type_page.dart';
import 'package:dental_app/features/financial_and_billing/presentation/pages/financial_page.dart';
import 'package:dental_app/features/home/presentation/widgets/active_treatment_plan_card.dart';
import 'package:dental_app/features/home/presentation/widgets/assistant_hero_card.dart';
import 'package:dental_app/features/home/presentation/widgets/quick_action_card.dart';
import 'package:dental_app/features/home/presentation/widgets/upcoming_appointment_card.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/medical_archive_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// تبويب "الرئيسية". "نصيحة اليوم" مستثناة عمداً حالياً بناءً على طلبك.
/// كل البيانات هون تجريبية (TODO عالمكان المناسب لما يوصل الـ backend).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // TODO: بدّلي هالاسم باسم المريض الحقيقي بعد تسجيل الدخول.
  static const _patientName = 'Abdullah';

  // تحية حسب وقت اليوم الفعلي - بدل ما تكون ثابتة "صباح الخير" دايماً
  // بغض النظر متى المريض فاتح التطبيق.
  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning'.tr();
    if (hour < 17) return 'Good afternoon'.tr();
    return 'Good evening'.tr();
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
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/background3.png',
                // 'assets/backgrounds/1.png',
                fit: BoxFit.cover,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  FadeSlideIn(
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
                            children: [
                              Text(
                                'Welcome'.tr(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.onSurface.withOpacity(0.55),
                                ),
                              ),
                              Text(
                                '${_greeting()}, $_patientName',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          // TODO: نقل لشاشة الإشعارات لما تجهز (قسم فرح، FR-P-13).
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications_outlined,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 60),
                    child: const UpcomingAppointmentCard(
                      treatmentName: 'Teeth Cleaning',
                      dateTimeLabel: 'Sunday, March 12 | 02:00 PM',
                      statusLabel: 'Confirmed',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 120),
                    child: AssistantHeroCard(
                      onStartChat: () {
                        // TODO: navigate to the chatbot page once it's built.
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 180),
                    child: ActiveTreatmentPlanCard(
                      planName: 'Metal Braces',
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
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.35,
                      children: [
                        QuickActionCard(
                          icon: Icons.description_outlined,
                          label: 'My Medical Record'.tr(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicalArchivePage(),
                              ),
                            );
                          },
                        ),
                        QuickActionCard(
                          icon: Icons.add_circle_outline_rounded,
                          label: 'Book Appointment'.tr(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectVisitTypePage(),
                              ),
                            );
                          },
                        ),
                        QuickActionCard(
                          icon: Icons.warning_amber_rounded,
                          label: 'Emergency Appointment'.tr(),
                          isDanger: true,
                          onTap: () {
                            // TODO: navigate to emergency contact flow.
                          },
                        ),
                        QuickActionCard(
                          icon: Icons.receipt_long_outlined,
                          label: 'Invoices'.tr(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
