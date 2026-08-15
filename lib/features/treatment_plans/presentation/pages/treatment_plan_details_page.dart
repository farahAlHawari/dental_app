import 'package:dental_app/core/utils/patient_status_guard.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_date_time_page.dart';
import 'package:dental_app/features/archived_visits/presentation/widgets/ratingDialog.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_invoice.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session_files.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan.dart';
import 'package:dental_app/features/treatment_plans/presentation/bloc/treatment_plans_bloc.dart';
import 'package:dental_app/features/treatment_plans/presentation/pages/plan_files_page.dart';
import 'package:dental_app/features/treatment_plans/presentation/pages/plan_invoices_page.dart';
import 'package:dental_app/features/treatment_plans/presentation/pages/treatment_session_details_page.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/plan_files_hub.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/plan_invoices_entry_card.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/plan_session_timeline.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/treatment_plan_hero_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TreatmentPlanDetailsPage extends StatefulWidget {
  final String planId;

  const TreatmentPlanDetailsPage({super.key, required this.planId});

  @override
  State<TreatmentPlanDetailsPage> createState() =>
      _TreatmentPlanDetailsPageState();
}

class _TreatmentPlanDetailsPageState extends State<TreatmentPlanDetailsPage> {
  TreatmentPlan? _plan;
  String? _patientId;
  bool _awaitingRatingReload = false;
  PlanInvoiceSummary? _invoiceSummary;
  int? _invoiceCount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;

    if (patientId == null || patientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No patient selected'.tr())),
      );
      return;
    }

    _patientId = patientId;
    await ShimmerPreview.wait();
    if (!mounted) return;
    final bloc = context.read<TreatmentPlansBloc>();
    bloc.add(
      LoadTreatmentPlanDetailRequested(
        patientId: patientId,
        planId: widget.planId,
      ),
    );
    bloc.add(
      LoadPlanInvoicesRequested(
        patientId: patientId,
        planId: widget.planId,
      ),
    );
  }

  Future<void> _bookSession(PlanSession session) async {
    if (!await PatientStatusGuard.ensureSelectedPatientEditable(context)) {
      return;
    }
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AppointmentsBloc(),
          child: SelectDateTimePage(
            visitTypeLabel: session.title,
            bookingType: AppointmentBookingType.followUp,
            treatmentSessionId: session.id,
          ),
        ),
      ),
    );
    if (mounted) await _load();
  }

  void _openFiles(PlanFileKind kind) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TreatmentPlansBloc>(),
          child: PlanFilesPage(
            planId: widget.planId,
            planName: _plan?.name ?? '',
            kind: kind,
          ),
        ),
      ),
    );
  }

  Future<void> _openInvoices() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TreatmentPlansBloc>(),
          child: PlanInvoicesPage(
            planId: widget.planId,
          ),
        ),
      ),
    );
    if (mounted) await _load();
  }

  Future<void> _openSession(PlanSession session) async {
    final plan = _plan;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TreatmentPlansBloc>(),
          child: TreatmentSessionDetailsPage(
            planId: widget.planId,
            planName: plan?.name ?? '',
            session: session,
          ),
        ),
      ),
    );
    if (mounted) await _load();
  }

  Future<void> _rateSession(PlanSession session) async {
    if (!await PatientStatusGuard.ensureSelectedPatientEditable(context)) {
      return;
    }
    if (!mounted) return;

    final patientId = _patientId;
    if (patientId == null || patientId.isEmpty) return;

    final selected = await showDialog<int>(
      context: context,
      builder: (_) => RatingDialog(sessionTitle: session.title),
    );
    if (selected == null || selected < 1 || !mounted) return;

    setState(() => _awaitingRatingReload = true);
    context.read<TreatmentPlansBloc>().add(
          RatePlanSessionRequested(
            patientId: patientId,
            planId: widget.planId,
            sessionId: session.id,
            rating: selected,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Treatment Plan Details'.tr(),
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
              child: BlocConsumer<TreatmentPlansBloc, TreatmentPlansState>(
                listener: (context, state) {
                  if (state is TreatmentPlanDetailSuccess) {
                    setState(() => _plan = state.plan);
                    if (_awaitingRatingReload) {
                      _awaitingRatingReload = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Thank you for your rating'.tr()),
                        ),
                      );
                    }
                  } else if (state is PlanInvoicesSuccess) {
                    setState(() {
                      _invoiceSummary = state.summary;
                      _invoiceCount = state.total;
                    });
                  } else if (state is TreatmentPlanDetailFailure) {
                    _awaitingRatingReload = false;
                    if (_plan != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errMessage)),
                      );
                    }
                  } else if (state is RatePlanSessionFailure) {
                    _awaitingRatingReload = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    current is TreatmentPlanDetailLoading ||
                    current is TreatmentPlanDetailSuccess ||
                    current is TreatmentPlanDetailFailure ||
                    current is TreatmentPlansInitial,
                builder: (context, state) {
                  if (_plan == null && state is! TreatmentPlanDetailFailure) {
                    return const TreatmentPlanDetailsShimmer();
                  }

                  if (state is TreatmentPlanDetailFailure && _plan == null) {
                    return Center(
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
                    );
                  }

                  final plan = _plan;
                  if (plan == null) {
                    return const SizedBox.shrink();
                  }

                  return RefreshIndicator(
                    onRefresh: _load,
                    color: colors.primary,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                      children: [
                        FadeSlideIn(
                          child: TreatmentPlanHeroCard(plan: plan),
                        ),
                        const SizedBox(height: 22),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 40),
                          child: PlanFilesHub(
                            plan: plan,
                            onOpen: _openFiles,
                          ),
                        ),
                        const SizedBox(height: 14),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 60),
                          child: PlanInvoicesEntryCard(
                            onTap: _openInvoices,
                            summary: _invoiceSummary,
                            invoiceCount: _invoiceCount,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Sessions'.tr(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (plan.sessions.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: EmptyListState(
                              message: 'No sessions in this plan'.tr(),
                              animationSize: 120,
                            ),
                          )
                        else
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 80),
                            child: PlanSessionTimeline(
                              sessions: plan.sessions,
                              highlightedIndex: plan.highlightedSessionIndex,
                              onBook: _bookSession,
                              onRate: _rateSession,
                              onOpen: _openSession,
                            ),
                          ),
                      ],
                    ),
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
