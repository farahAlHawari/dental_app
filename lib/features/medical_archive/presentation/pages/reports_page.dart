import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/medical_archive/domain/medical_archive_helper.dart';
import 'package:dental_app/features/medical_archive/presentation/bloc/medical_archive_bloc.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/report_viewer_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MedicalArchiveBloc(),
      child: const _ReportsView(),
    );
  }
}

class _ReportsView extends StatefulWidget {
  const _ReportsView();

  @override
  State<_ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<_ReportsView> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;
    if (patientId == null || patientId.isEmpty) {
      setState(() => _items = []);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No patient selected'.tr())),
      );
      return;
    }
    // TEMP preview delay — remove later if not needed.
    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<MedicalArchiveBloc>().add(
          LoadMedicalArchiveRequested(
            patientId: patientId,
            type: MedicalArchiveHelper.typeReport,
          ),
        );
  }

  void _openReport(Map<String, dynamic> item) {
    final url = MedicalArchiveHelper.mediaPublicUrl(item) ?? '';
    final title = MedicalArchiveHelper.titleOf(item).isEmpty
        ? 'Report'.tr()
        : MedicalArchiveHelper.titleOf(item);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportViewerPage(
          pdfUrl: url,
          title: title,
          planSessionLabel: MedicalArchiveHelper.planSessionLabel(item),
          date: MedicalArchiveHelper.formatDateOf(item),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: ColoredBox(
        color: scheme.surfaceContainerHighest,
        child: BlocConsumer<MedicalArchiveBloc, MedicalArchiveState>(
          listener: (context, state) {
            if (state is MedicalArchiveSuccess &&
                state.type == MedicalArchiveHelper.typeReport) {
              setState(() => _items = List.from(state.items));
            } else if (state is MedicalArchiveFailure &&
                state.type == MedicalArchiveHelper.typeReport) {
              setState(() => _items = []);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errMessage)),
              );
            }
          },
          buildWhen: (previous, current) =>
              current is MedicalArchiveLoading ||
              current is MedicalArchiveSuccess ||
              current is MedicalArchiveFailure ||
              current is MedicalArchiveInitial,
          builder: (context, state) {
            final loading = (state is MedicalArchiveLoading &&
                    state.type == MedicalArchiveHelper.typeReport) ||
                (state is MedicalArchiveInitial && _items.isEmpty);

            if (loading) {
              return const MedicalArchiveListShimmer(showThumbnail: false);
            }

            if (_items.isEmpty) {
              return EmptyListState(message: 'No reports'.tr());
            }

            return RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final title = MedicalArchiveHelper.titleOf(item).isEmpty
                      ? 'Report'.tr()
                      : MedicalArchiveHelper.titleOf(item);
                  final planSession =
                      MedicalArchiveHelper.planSessionLabel(item);
                  final date = MedicalArchiveHelper.formatDateOf(item);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _openReport(item),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: scheme.shadow.withOpacity(0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            LottieBuilder.asset(
                              'assets/animations/5.json',
                              width: 90,
                              repeat: true,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  12,
                                  12,
                                  12,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: onSurface,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (planSession.isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.medical_information_outlined,
                                            color: scheme.primary,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              planSession,
                                              maxLines: 2,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: onSurface
                                                    .withOpacity(0.7),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: scheme.primary,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          date,
                                          style: TextStyle(
                                            color:
                                                onSurface.withOpacity(0.7),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
