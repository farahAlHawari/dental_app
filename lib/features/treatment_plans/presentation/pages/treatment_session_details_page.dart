import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_date_time_page.dart';
import 'package:dental_app/features/appointments/presentation/utils/appointment_date_format.dart';
import 'package:dental_app/features/archived_visits/presentation/widgets/ratingDialog.dart';
import 'package:dental_app/features/home/presentation/widgets/quick_action_card.dart';
import 'package:dental_app/features/medical_archive/domain/medical_archive_helper.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session_files.dart';
import 'package:dental_app/features/treatment_plans/data/models/session_encounter.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_session_status.dart';
import 'package:dental_app/features/treatment_plans/presentation/bloc/treatment_plans_bloc.dart';
import 'package:dental_app/features/treatment_plans/presentation/pages/session_files_page.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/plan_before_after_card.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/session_status_badge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TreatmentSessionDetailsPage extends StatefulWidget {
  final String planId;
  final String planName;
  final PlanSession session;

  const TreatmentSessionDetailsPage({
    super.key,
    required this.planId,
    required this.planName,
    required this.session,
  });

  @override
  State<TreatmentSessionDetailsPage> createState() =>
      _TreatmentSessionDetailsPageState();
}

class _TreatmentSessionDetailsPageState
    extends State<TreatmentSessionDetailsPage> {
  late PlanSession _session;
  bool _awaitingRatingReload = false;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  Future<void> _refresh() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted || patientId == null || patientId.isEmpty) return;
    context.read<TreatmentPlansBloc>().add(
          LoadTreatmentPlanDetailRequested(
            patientId: patientId,
            planId: widget.planId,
          ),
        );
  }

  Future<void> _rateSession() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted || patientId == null || patientId.isEmpty) return;

    final selected = await showDialog<int>(
      context: context,
      builder: (_) => RatingDialog(sessionTitle: _title),
    );
    if (selected == null || selected < 1 || !mounted) return;

    setState(() => _awaitingRatingReload = true);
    context.read<TreatmentPlansBloc>().add(
          RatePlanSessionRequested(
            patientId: patientId,
            planId: widget.planId,
            sessionId: _session.id,
            rating: selected,
          ),
        );
  }

  Future<void> _bookSession() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AppointmentsBloc(),
          child: SelectDateTimePage(
            visitTypeLabel: _title,
            bookingType: AppointmentBookingType.followUp,
            treatmentSessionId: _session.id,
          ),
        ),
      ),
    );
    if (mounted) await _refresh();
  }

  void _openSessionFiles(PlanFileKind kind) {
    final encounter = _session.encounter;
    final type = kind == PlanFileKind.reports ? 'REPORT' : 'XRAY';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SessionFilesPage(
          kind: kind,
          sessionLabel: _title,
          attachments: encounter?.attachmentsOf(type) ?? const [],
        ),
      ),
    );
  }

  String get _title {
    if (_session.title.isNotEmpty) return _session.title;
    return '${'Session'.tr()} ${_session.sessionOrder}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final encounter = _session.encounter;
    final reports = encounter?.attachmentsOf('REPORT') ?? const [];
    final radiographs = encounter?.attachmentsOf('XRAY') ?? const [];
    final photoPair = PlanSessionFilesMapper.pairPhotoAttachments(
      encounter?.attachments ?? const [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Session details'.tr(),
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
              child: BlocListener<TreatmentPlansBloc, TreatmentPlansState>(
                listener: (context, state) {
                  if (state is TreatmentPlanDetailSuccess) {
                    final updated = state.plan.sessions.where(
                      (s) => s.id == _session.id,
                    );
                    if (updated.isNotEmpty) {
                      setState(() => _session = updated.first);
                    }
                    if (_awaitingRatingReload) {
                      _awaitingRatingReload = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Thank you for your rating'.tr()),
                        ),
                      );
                    }
                  } else if (state is RatePlanSessionFailure) {
                    _awaitingRatingReload = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  }
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  children: [
                    FadeSlideIn(child: _SummaryCard(session: _session)),
                    if (_session.isBookablePending) ...[
                      const SizedBox(height: 12),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 40),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _bookSession,
                            icon: const Icon(Icons.calendar_month_rounded),
                            label: Text('Book this session now'.tr()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (_session.pendingRatingEnabled) ...[
                      const SizedBox(height: 12),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 50),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _rateSession,
                            icon: const Icon(Icons.star_outline_rounded),
                            label: Text('Rate your visit'.tr()),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colors.primary,
                              side: BorderSide(
                                color: colors.primary.withOpacity(0.3),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (encounter != null && encounter.hasTextContent) ...[
                      const SizedBox(height: 22),
                      Text(
                        'Clinical record'.tr(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 80),
                        child: _ClinicalCard(encounter: encounter),
                      ),
                    ] else if (_session.status ==
                        TreatmentSessionStatus.completed) ...[
                      const SizedBox(height: 22),
                      Text(
                        'No clinical notes recorded for this session.'.tr(),
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: colors.onSurface.withOpacity(0.55),
                        ),
                      ),
                    ],
                    if (photoPair != null) ...[
                      const SizedBox(height: 22),
                      Text(
                        'Before and After'.tr(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 70),
                        child: PlanBeforeAfterCard(
                          title: '',
                          date: MedicalArchiveHelper.formatDate(
                            photoPair.createdAt?.toIso8601String(),
                          ),
                          beforeImageUrl: photoPair.before.publicUrl ?? '',
                          afterImageUrl: photoPair.after.publicUrl ?? '',
                        ),
                      ),
                    ],
                    if (reports.isNotEmpty || radiographs.isNotEmpty) ...[
                      const SizedBox(height: 22),
                      Text(
                        'Session files'.tr(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 90),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 1.05,
                          children: [
                            if (reports.isNotEmpty)
                              QuickActionCard(
                                icon: Icons.description_outlined,
                                label: 'Reports'.tr(),
                                subtitle: '{count} files'.tr(
                                  namedArgs: {'count': '${reports.length}'},
                                ),
                                onTap: () =>
                                    _openSessionFiles(PlanFileKind.reports),
                              ),
                            if (radiographs.isNotEmpty)
                              QuickActionCard(
                                icon: Icons.photo_filter_outlined,
                                label: 'Radiographs'.tr(),
                                subtitle: '{count} files'.tr(
                                  namedArgs: {
                                    'count': '${radiographs.length}',
                                  },
                                ),
                                onTap: () => _openSessionFiles(
                                  PlanFileKind.radiographs,
                                ),
                              ),
                          ],
                        ),
                      ),
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

class _SummaryCard extends StatelessWidget {
  final PlanSession session;

  const _SummaryCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = session.title.isEmpty
        ? '${'Session'.tr()} ${session.sessionOrder}'
        : session.title;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(isDark ? 0.30 : 0.10),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SessionStatusBadge(session: session),
              const Spacer(),
              Text(
                '${'Session'.tr()} ${session.sessionOrder}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.primary,
              height: 1.35,
            ),
          ),
          if (session.completedAt != null) ...[
            const SizedBox(height: 10),
            _MetaRow(
              icon: Icons.event_outlined,
              label: formatAppointmentDate(session.completedAt!),
            ),
          ],
          if (session.durationMinutes != null &&
              session.durationMinutes! > 0) ...[
            const SizedBox(height: 8),
            _MetaRow(
              icon: Icons.schedule_rounded,
              label: '${session.durationMinutes} ${'min'.tr()}',
            ),
          ],
          if (session.showEstimatedCost) ...[
            const SizedBox(height: 8),
            _MetaRow(
              icon: Icons.payments_outlined,
              label: '${'Estimated cost'.tr()}: ${session.estimatedCost}',
            ),
          ],
          if (session.rating != null && session.rating! > 0) ...[
            const SizedBox(height: 14),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star_rounded,
                  size: 22,
                  color: index < session.rating!
                      ? AppColors.accent
                      : colors.outline.withOpacity(0.35),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colors.onSurface.withOpacity(0.75),
            ),
          ),
        ),
      ],
    );
  }
}

class _ClinicalCard extends StatelessWidget {
  final SessionEncounter encounter;

  const _ClinicalCard({required this.encounter});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(isDark ? 0.22 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (encounter.diagnosis != null)
            _ClinicalBlock(
              icon: Icons.health_and_safety_outlined,
              title: 'Diagnosis'.tr(),
              body: encounter.diagnosis!,
            ),
          if (encounter.clinicalNotes != null) ...[
            if (encounter.diagnosis != null) const Divider(height: 24),
            _ClinicalBlock(
              icon: Icons.notes_rounded,
              title: 'Clinical notes'.tr(),
              body: encounter.clinicalNotes!,
            ),
          ],
          if (encounter.prescription != null) ...[
            if (encounter.diagnosis != null || encounter.clinicalNotes != null)
              const Divider(height: 24),
            _ClinicalBlock(
              icon: Icons.medication_outlined,
              title: 'Prescription'.tr(),
              body: encounter.prescription!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ClinicalBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _ClinicalBlock({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: colors.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
