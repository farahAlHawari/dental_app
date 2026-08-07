import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/archived_visits/domain/session_rating_helper.dart';
import 'package:dental_app/features/archived_visits/presentation/bloc/archived_visits_bloc.dart';
import 'package:dental_app/features/archived_visits/presentation/widgets/ratingDialog.dart';
import 'package:dental_app/features/archived_visits/presentation/widgets/visit_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchivedVisitsPage extends StatelessWidget {
  const ArchivedVisitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArchivedVisitsBloc(),
      child: const _ArchivedVisitsView(),
    );
  }
}

class _ArchivedVisitsView extends StatefulWidget {
  const _ArchivedVisitsView();

  @override
  State<_ArchivedVisitsView> createState() => _ArchivedVisitsViewState();
}

class _ArchivedVisitsViewState extends State<_ArchivedVisitsView> {
  List<Map<String, dynamic>> _sessions = [];
  String? _patientId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;

    if (patientId == null || patientId.isEmpty) {
      setState(() {
        _sessions = [];
        _patientId = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No patient selected'.tr())),
      );
      return;
    }

    _patientId = patientId;
    // TEMP preview delay — remove later if not needed.
    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<ArchivedVisitsBloc>().add(
          LoadCompletedSessionsRequested(patientId: patientId),
        );
  }

  Future<void> _rateSession(int index) async {
    final session = _sessions[index];
    final sessionId = (session['id'] ?? '').toString();
    final title = (session['title'] ?? '').toString();
    final patientId = _patientId;
    if (patientId == null || sessionId.isEmpty) return;

    final selected = await showDialog<int>(
      context: context,
      builder: (_) => RatingDialog(sessionTitle: title),
    );
    if (selected == null || selected < 1 || !mounted) return;

    context.read<ArchivedVisitsBloc>().add(
          RateSessionRequested(
            patientId: patientId,
            sessionId: sessionId,
            rating: selected,
            sessionIndex: index,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Archived Visits'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/background5.png',
                color: Theme.of(context).colorScheme.primary,
                fit: BoxFit.cover,
              ),
            ),
            BlocConsumer<ArchivedVisitsBloc, ArchivedVisitsState>(
              listener: (context, state) {
                if (state is CompletedSessionsSuccess) {
                  setState(() => _sessions = List.from(state.sessions));
                } else if (state is CompletedSessionsFailure) {
                  setState(() => _sessions = []);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errMessage)),
                  );
                } else if (state is RateSessionSuccess) {
                  final index = state.sessionIndex;
                  if (index != null &&
                      index >= 0 &&
                      index < _sessions.length) {
                    setState(() {
                      _sessions[index] = {
                        ..._sessions[index],
                        ...state.session,
                        'pendingRating': null,
                        'rating': state.session['rating'] ??
                            _sessions[index]['rating'],
                      };
                    });
                  }
                } else if (state is RateSessionFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errMessage)),
                  );
                }
              },
              buildWhen: (previous, current) =>
                  current is CompletedSessionsLoading ||
                  current is CompletedSessionsSuccess ||
                  current is CompletedSessionsFailure ||
                  current is ArchivedVisitsInitial,
              builder: (context, state) {
                final loading = state is CompletedSessionsLoading ||
                    (state is ArchivedVisitsInitial && _sessions.isEmpty);

                if (loading) {
                  return const ArchivedVisitsListShimmer();
                }

                if (state is CompletedSessionsFailure && _sessions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.errMessage, textAlign: TextAlign.center),
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

                if (_sessions.isEmpty) {
                  return Center(child: Text('No completed visits'.tr()));
                }

                return RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    itemCount: _sessions.length,
                    itemBuilder: (context, index) {
                      final session = _sessions[index];
                      final title = (session['title'] ?? 'Session'.tr())
                          .toString();
                      final planName = session['planName']?.toString();
                      final dateLabel =
                          SessionRatingHelper.formatCompletedDate(
                        session['completedAt']?.toString(),
                      );
                      final timeLabel =
                          SessionRatingHelper.formatCompletedTime(
                        session['completedAt']?.toString(),
                      );
                      final canRate = SessionRatingHelper.canRate(session);
                      final rating = SessionRatingHelper.ratingOf(session);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: VisitCard(
                          title: title,
                          dateLabel: dateLabel,
                          timeLabel: timeLabel,
                          planName: planName,
                          rating: rating,
                          canRate: canRate,
                          onRatePressed:
                              canRate ? () => _rateSession(index) : null,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
