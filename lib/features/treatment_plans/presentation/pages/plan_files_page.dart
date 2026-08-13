import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/medical_archive/domain/medical_archive_helper.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/report_viewer_page.dart';
import 'package:dental_app/features/medical_archive/presentation/widgets/radiograph_card.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session_files.dart';
import 'package:dental_app/features/treatment_plans/presentation/bloc/treatment_plans_bloc.dart';
import 'package:dental_app/features/treatment_plans/presentation/pages/plan_prescription_details_page.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/plan_archive_file_row.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/plan_before_after_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanFilesPage extends StatefulWidget {
  final String planId;
  final String planName;
  final PlanFileKind kind;

  const PlanFilesPage({
    super.key,
    required this.planId,
    required this.planName,
    required this.kind,
  });

  @override
  State<PlanFilesPage> createState() => _PlanFilesPageState();
}

class _PlanFilesPageState extends State<PlanFilesPage> {
  List<PlanSessionFiles> _sessions = [];
  bool _ready = false;

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
        _ready = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No patient selected'.tr())),
      );
      return;
    }

    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<TreatmentPlansBloc>().add(
          LoadPlanSessionFilesRequested(
            patientId: patientId,
            planId: widget.planId,
            kind: widget.kind,
          ),
        );
  }

  String _sessionLabel(PlanSessionFiles session) {
    if (session.title.isNotEmpty) return session.title;
    if (widget.planName.isNotEmpty) return widget.planName;
    return 'Session {order}'.tr(
      namedArgs: {'order': '${session.sessionOrder}'},
    );
  }

  String _fileTitle(PlanFileItem item, String fallbackKey) {
    final title = item.attachment.title?.trim() ?? '';
    if (title.isNotEmpty) return title;
    return fallbackKey.tr();
  }

  void _openReport(PlanFileItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportViewerPage(
          pdfUrl: item.attachment.publicUrl ?? '',
          title: _fileTitle(item, 'Report'),
          planSessionLabel: _sessionLabel(item.session),
          date: MedicalArchiveHelper.formatDate(
            item.createdAt?.toIso8601String(),
          ),
        ),
      ),
    );
  }

  void _openPrescription(PlanPrescriptionItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlanPrescriptionDetailsPage(
          title: 'Prescription'.tr(),
          sessionLabel: _sessionLabel(item.session),
          text: item.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final showThumbnail = widget.kind == PlanFileKind.radiographs ||
        widget.kind == PlanFileKind.beforeAfter;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.kind.titleKey.tr(),
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
                  if (state is PlanSessionFilesSuccess &&
                      state.kind == widget.kind) {
                    setState(() {
                      _sessions = List.from(state.sessions);
                      _ready = true;
                    });
                  } else if (state is PlanSessionFilesFailure &&
                      state.kind == widget.kind) {
                    setState(() {
                      _sessions = [];
                      _ready = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    (current is PlanSessionFilesLoading &&
                        current.kind == widget.kind) ||
                    (current is PlanSessionFilesSuccess &&
                        current.kind == widget.kind) ||
                    (current is PlanSessionFilesFailure &&
                        current.kind == widget.kind),
                builder: (context, state) {
                  final loading = !_ready;

                  if (loading) {
                    return MedicalArchiveListShimmer(
                      showThumbnail: showThumbnail,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _load,
                    color: colors.primary,
                    child: _buildBody(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (widget.kind) {
      case PlanFileKind.radiographs:
        return _buildRadiographs();
      case PlanFileKind.reports:
        return _buildReports();
      case PlanFileKind.prescriptions:
        return _buildPrescriptions();
      case PlanFileKind.beforeAfter:
        return _buildBeforeAfter();
    }
  }

  Widget _empty() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        EmptyListState(message: widget.kind.emptyMessageKey.tr()),
      ],
    );
  }

  Widget _buildRadiographs() {
    final items = PlanSessionFilesMapper.flattenAttachments(
      _sessions,
      type: 'XRAY',
    );
    if (items.isEmpty) return _empty();

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: RadiographCard(
            imageUrl: item.attachment.publicUrl ?? '',
            title: _fileTitle(item, 'Radiograph'),
            planSessionLabel: _sessionLabel(item.session),
            date: MedicalArchiveHelper.formatDate(
              item.createdAt?.toIso8601String(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReports() {
    final items = PlanSessionFilesMapper.flattenAttachments(
      _sessions,
      type: 'REPORT',
    );
    if (items.isEmpty) return _empty();

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return PlanArchiveFileRow(
          lottieAsset: 'assets/animations/5.json',
          title: _fileTitle(item, 'Report'),
          sessionLabel: _sessionLabel(item.session),
          date: MedicalArchiveHelper.formatDate(
            item.createdAt?.toIso8601String(),
          ),
          onTap: () => _openReport(item),
        );
      },
    );
  }

  Widget _buildPrescriptions() {
    final items = PlanSessionFilesMapper.prescriptions(_sessions);
    if (items.isEmpty) return _empty();

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return PlanArchiveFileRow(
          lottieAsset: 'assets/animations/3.json',
          title: 'Prescription'.tr(),
          sessionLabel: _sessionLabel(item.session),
          date: '',
          onTap: () => _openPrescription(item),
        );
      },
    );
  }

  Widget _buildBeforeAfter() {
    final pairs = PlanSessionFilesMapper.photoPairs(_sessions);
    if (pairs.isEmpty) return _empty();

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: pairs.length,
      itemBuilder: (context, index) {
        final pair = pairs[index];
        return PlanBeforeAfterCard(
          title: _sessionLabel(pair.session),
          date: MedicalArchiveHelper.formatDate(
            pair.createdAt?.toIso8601String(),
          ),
          beforeImageUrl: pair.before.publicUrl ?? '',
          afterImageUrl: pair.after.publicUrl ?? '',
        );
      },
    );
  }
}
