import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/features/medical_archive/domain/medical_archive_helper.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/report_viewer_page.dart';
import 'package:dental_app/features/medical_archive/presentation/widgets/radiograph_card.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session_files.dart';
import 'package:dental_app/features/treatment_plans/data/models/session_encounter.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/plan_archive_file_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SessionFilesPage extends StatelessWidget {
  final PlanFileKind kind;
  final String sessionLabel;
  final List<SessionAttachment> attachments;

  const SessionFilesPage({
    super.key,
    required this.kind,
    required this.sessionLabel,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          kind.titleKey.tr(),
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
            SafeArea(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (attachments.isEmpty) {
      return EmptyListState(message: kind.emptyMessageKey.tr());
    }

    if (kind == PlanFileKind.radiographs) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        itemCount: attachments.length,
        itemBuilder: (context, index) {
          final item = attachments[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RadiographCard(
              imageUrl: item.publicUrl ?? '',
              title: _fileTitle(item, 'Radiograph'),
              planSessionLabel: sessionLabel,
              date: MedicalArchiveHelper.formatDate(
                item.createdAt?.toIso8601String(),
              ),
            ),
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: attachments.length,
      itemBuilder: (context, index) {
        final item = attachments[index];
        return PlanArchiveFileRow(
          lottieAsset: 'assets/animations/5.json',
          title: _fileTitle(item, 'Report'),
          sessionLabel: sessionLabel,
          date: MedicalArchiveHelper.formatDate(
            item.createdAt?.toIso8601String(),
          ),
          onTap: () => _openReport(context, item),
        );
      },
    );
  }

  String _fileTitle(SessionAttachment item, String fallbackKey) {
    final title = item.title?.trim() ?? '';
    if (title.isNotEmpty) return title;
    final original = item.originalName?.trim() ?? '';
    if (original.isNotEmpty) return original;
    return fallbackKey.tr();
  }

  void _openReport(BuildContext context, SessionAttachment item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportViewerPage(
          pdfUrl: item.publicUrl ?? '',
          title: _fileTitle(item, 'Report'),
          planSessionLabel: sessionLabel,
          date: MedicalArchiveHelper.formatDate(
            item.createdAt?.toIso8601String(),
          ),
        ),
      ),
    );
  }
}
