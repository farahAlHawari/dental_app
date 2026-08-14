import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/home/presentation/pages/main_navigation_page.dart';
import 'package:dental_app/features/medical_archive/presentation/widgets/tab_botton.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan.dart';
import 'package:dental_app/features/treatment_plans/presentation/bloc/treatment_plans_bloc.dart';
import 'package:dental_app/features/treatment_plans/presentation/pages/treatment_plan_details_page.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/treatment_plan_list_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// تبويب "خططي العلاجية" — نشطة / مكتملة فقط.
class TreatmentPlansPage extends StatelessWidget {
  const TreatmentPlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TreatmentPlansBloc(),
      child: const _TreatmentPlansView(),
    );
  }
}

class _TreatmentPlansView extends StatefulWidget {
  const _TreatmentPlansView();

  @override
  State<_TreatmentPlansView> createState() => _TreatmentPlansViewState();
}

class _TreatmentPlansViewState extends State<_TreatmentPlansView> {
  int _tabIndex = 0;
  List<TreatmentPlan> _active = [];
  List<TreatmentPlan> _completed = [];

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
        _active = [];
        _completed = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No patient selected'.tr())),
      );
      return;
    }

    context.read<TreatmentPlansBloc>().add(
          LoadTreatmentPlansListRequested(patientId: patientId),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final items = _tabIndex == 0 ? _active : _completed;

    return Scaffold(
      appBar: AppBar(
        leading: MainNavigationPage.homeTabBackButton(context),
        title: Text(
          'My Treatment Plans'.tr(),
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
                  if (state is TreatmentPlansListSuccess) {
                    setState(() {
                      _active = List.from(state.active);
                      _completed = List.from(state.completed);
                    });
                    if (state.warningMessage != null &&
                        state.warningMessage!.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.warningMessage!)),
                      );
                    }
                  } else if (state is TreatmentPlansListFailure) {
                    setState(() {
                      _active = [];
                      _completed = [];
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    current is TreatmentPlansListLoading ||
                    current is TreatmentPlansListSuccess ||
                    current is TreatmentPlansListFailure ||
                    current is TreatmentPlansInitial,
                builder: (context, state) {
                  final loading = state is TreatmentPlansListLoading ||
                      (state is TreatmentPlansInitial &&
                          _active.isEmpty &&
                          _completed.isEmpty);

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: _PlansTabBar(
                          selectedIndex: _tabIndex,
                          onChanged: (index) =>
                              setState(() => _tabIndex = index),
                        ),
                      ),
                      Expanded(
                        child: loading
                            ? const TreatmentPlansListShimmer()
                            : (state is TreatmentPlansListFailure &&
                                    _active.isEmpty &&
                                    _completed.isEmpty)
                                ? Center(
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
                                  )
                                : RefreshIndicator(
                                    onRefresh: _load,
                                    color: colors.primary,
                                    child: items.isEmpty
                                        ? ListView(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.22,
                                              ),
                                              EmptyListState(
                                                message: (_tabIndex == 0
                                                        ? 'No active treatment plans'
                                                        : 'No completed treatment plans')
                                                    .tr(),
                                                animationSize: 140,
                                              ),
                                            ],
                                          )
                                        : ListView.builder(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            padding: const EdgeInsets.fromLTRB(
                                              16,
                                              10,
                                              16,
                                              100,
                                            ),
                                            itemCount: items.length,
                                            itemBuilder: (context, index) {
                                              final plan = items[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 14,
                                                ),
                                                child: FadeSlideIn(
                                                  delay: Duration(
                                                    milliseconds: 60 * index,
                                                  ),
                                                  child: TreatmentPlanListCard(
                                                    plan: plan,
                                                    onViewDetails: () {
                                                      final bloc = context.read<
                                                          TreatmentPlansBloc>();
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              BlocProvider
                                                                  .value(
                                                            value: bloc,
                                                            child:
                                                                TreatmentPlanDetailsPage(
                                                              planId: plan.id,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                      ),
                    ],
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

class _PlansTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _PlansTabBar({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TabButton(
              text: 'Active Plans'.tr(),
              selected: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: TabButton(
              text: 'Completed Plans'.tr(),
              selected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}
