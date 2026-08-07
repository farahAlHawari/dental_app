import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/archived_visits/domain/session_rating_helper.dart';
import 'package:dental_app/features/archived_visits/presentation/bloc/archived_visits_bloc.dart';
import 'package:dental_app/features/archived_visits/presentation/widgets/ratingDialog.dart';
import 'package:dental_app/features/profile/presentation/pages/profile_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Temporary home shell after auth / patient onboarding.
/// Uses ArchivedVisitsBloc for GET /home + rate.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArchivedVisitsBloc(),
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatefulWidget {
  const _HomePageView();

  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  bool _dialogOpen = false;
  String? _pendingSessionId;
  String? _patientId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestHome());
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

    _pendingSessionId = sessionId;
    context.read<ArchivedVisitsBloc>().add(
          RateSessionRequested(
            patientId: patientId,
            sessionId: sessionId,
            rating: selected,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        appBar: AppBar(
          title: Text('Home'.tr()),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Home (placeholder)'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Temporary screen until the real home is wired.'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                    if (mounted) await _requestHome();
                  },
                  icon: const Icon(Icons.person_outline),
                  label: Text('Profile'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
