import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:dental_app/features/appointments/presentation/pages/consultation_reason_page.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_follow_up_session_page.dart';
import 'package:dental_app/features/appointments/presentation/widgets/visit_type_card.dart';
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

class _SelectVisitTypeView extends StatelessWidget {
  const _SelectVisitTypeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress header
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
                    // بار التقدم عم يتحرك (يعبّي) أول ما تفتح الشاشة، بدل ما يطلع
                    // جاهز فجأة - هاي اللمسة البسيطة هي يلي كانت ناقصة إحساس الحركة.
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

                    // Title
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

                    // Card 1 — الاستشارة الأولية، بلون الـ primary تبع التطبيق
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
                        onTap: () {
                          final appointmentsBloc =
                              context.read<AppointmentsBloc>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: appointmentsBloc,
                                child: ConsultationReasonPage(
                                  visitTypeLabel:
                                      'Initial Consultation / First Visit'.tr(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Card 2 — المتابعة، بلون الـ accent الذهبي عشان تنفصل بصرياً
                    // عن الكرت الأول من أول نظرة، مش بس بالنص.
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 220),
                      child: VisitTypeCard(
                        title: 'Follow-up within an existing treatment plan'
                            .tr(),
                        subtitle:
                            'For registered patients to complete treatment sessions or scheduled periodic check-ups.'
                                .tr(),
                        actionText: 'Continue current plan'.tr(),
                        icon: Icons.assignment_outlined,
                        accentColor: AppColors.primary,
                        onTap: () {
                          final appointmentsBloc =
                              context.read<AppointmentsBloc>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: appointmentsBloc,
                                child: SelectFollowUpSessionPage(),
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
          ],
        ),
      ),
    );
  }
}
