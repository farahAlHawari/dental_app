import 'package:dental_app/core/utils/patient_status_guard.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/appointments/data/models/appointment_booking_type.dart';
import 'package:dental_app/features/appointments/data/models/bookable_session.dart';
import 'package:dental_app/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:dental_app/features/appointments/presentation/pages/select_date_time_page.dart';
import 'package:dental_app/features/appointments/presentation/widgets/bookable_session_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// جلسات المتابعة القابلة للحجز — GET treatment-sessions/for-booking
class SelectFollowUpSessionPage extends StatefulWidget {
  const SelectFollowUpSessionPage({super.key});

  @override
  State<SelectFollowUpSessionPage> createState() =>
      _SelectFollowUpSessionPageState();
}

class _SelectFollowUpSessionPageState extends State<SelectFollowUpSessionPage> {
  List<BookableSession> _sessions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;
    if (patientId == null || patientId.isEmpty) {
      setState(() => _sessions = []);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No patient selected'.tr())),
      );
      return;
    }

    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<AppointmentsBloc>().add(
          LoadBookableSessionsRequested(patientId: patientId),
        );
  }

  Future<void> _onBookSession(BuildContext context, BookableSession session) async {
    if (!session.canBook) return;
    if (!await PatientStatusGuard.ensureSelectedPatientEditable(context)) {
      return;
    }
    if (!context.mounted) return;

    final appointmentsBloc = context.read<AppointmentsBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: appointmentsBloc,
          child: SelectDateTimePage(
            visitTypeLabel: session.title,
            bookingType: AppointmentBookingType.followUp,
            treatmentSessionId: session.id,
          ),
        ),
      ),
    );
  }

  bool get _hasBookableSession => _sessions.any((s) => s.canBook);

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
              child: BlocConsumer<AppointmentsBloc, AppointmentsState>(
                listener: (context, state) {
                  if (state is BookableSessionsSuccess) {
                    setState(() => _sessions = List.from(state.sessions));
                  } else if (state is BookableSessionsFailure) {
                    setState(() => _sessions = []);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    current is BookableSessionsLoading ||
                    current is BookableSessionsSuccess ||
                    current is BookableSessionsFailure ||
                    current is AppointmentsInitial,
                builder: (context, state) {
                  final loading = state is BookableSessionsLoading ||
                      (state is AppointmentsInitial && _sessions.isEmpty);

                  return RefreshIndicator(
                    onRefresh: _load,
                    color: colors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                              builder: (context, value, _) =>
                                  LinearProgressIndicator(
                                value: value,
                                minHeight: 6,
                                backgroundColor:
                                    colors.primary.withOpacity(0.15),
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
                          if (loading)
                            const BookableSessionsListShimmer()
                          else if (state is BookableSessionsFailure &&
                              _sessions.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
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
                            )
                          else if (_sessions.isEmpty)
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 140),
                              child: EmptyListState(
                                message: 'No bookable sessions right now'.tr(),
                                animationSize: 140,
                              ),
                            )
                          else if (!_hasBookableSession)
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 140),
                              child: Column(
                                children: [
                                  EmptyListState(
                                    message:
                                        'No sessions ready to book yet'.tr(),
                                    animationSize: 120,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Complete earlier sessions in your plan first.'
                                        .tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colors.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  for (var i = 0; i < _sessions.length; i++) ...[
                                    BookableSessionCard(session: _sessions[i]),
                                    const SizedBox(height: 16),
                                  ],
                                ],
                              ),
                            )
                          else
                            for (var i = 0; i < _sessions.length; i++) ...[
                              FadeSlideIn(
                                delay: Duration(milliseconds: 140 + i * 80),
                                child: BookableSessionCard(
                                  session: _sessions[i],
                                  onBook: _sessions[i].canBook
                                      ? () => _onBookSession(
                                            context,
                                            _sessions[i],
                                          )
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                        ],
                      ),
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
