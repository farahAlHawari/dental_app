import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/appointments/presentation/widgets/bookable_session_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// الشاشة يلي بتطلع لما المريض يختار "متابعة ضمن خطة علاجية" — بتعرض
/// بس الجلسات القابلة للحجز هلق (كل خطة علاجية مفتوحة إلها جلسة وحدة
/// قابلة للحجز)، والمريض بيختار وحدة يحجزها. الخطوة 2 من 3، متل شاشة
/// الاستشارة تماماً بس بمحتوى مختلف.
class SelectFollowUpSessionPage extends StatelessWidget {
  const SelectFollowUpSessionPage({super.key});

  // TODO: بيانات تجريبية لحد ما توصل الشاشة مع الـ backend الحقيقي.
  static final List<BookableSession> _sessions = [
    BookableSession(
      title: 'Braces Adjustment Session'.tr(),
      description: 'Routine check-up and adjustment of the braces wires.'.tr(),
      planName: 'Orthodontic Treatment Plan'.tr(),
    ),
    BookableSession(
      title: 'Root Canal Follow-up Session'.tr(),
      description: 'Check-up and continuation of the root canal treatment.'
          .tr(),
      planName: 'Root Canal Treatment Plan'.tr(),
    ),
  ];

  void _onBookSession(BuildContext context, BookableSession session) {
    // TODO: navigate to the date & time selection page, passing the
    // chosen session along.
  }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Session'.tr(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Step 2 of 3'.tr(),
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
                        tween: Tween(begin: 0, end: 2 / 3),
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
                        'Which session would you like to book?'.tr(),
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
                        'These are the sessions available under your open treatment plans.'
                            .tr(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface.withOpacity(0.65),
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_sessions.isEmpty)
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 140),
                        child: _EmptySessionsNotice(
                          colors: colors,
                          theme: theme,
                        ),
                      )
                    else
                      for (var i = 0; i < _sessions.length; i++) ...[
                        FadeSlideIn(
                          delay: Duration(milliseconds: 140 + i * 80),
                          child: BookableSessionCard(
                            session: _sessions[i],
                            onBook: () => _onBookSession(context, _sessions[i]),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
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

/// بتبين وقت ما ما يكون في أي جلسة قابلة للحجز حالياً - بدل ما تضل
/// الشاشة فاضية بدون تفسير.
class _EmptySessionsNotice extends StatelessWidget {
  final ColorScheme colors;
  final ThemeData theme;

  const _EmptySessionsNotice({required this.colors, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(isDark ? 0.30 : 0.10),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 40,
            color: colors.onSurface.withOpacity(0.35),
          ),
          const SizedBox(height: 12),
          Text(
            'No bookable sessions right now'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "You don't currently have an open treatment plan with a session ready to book."
                .tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withOpacity(0.6),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
