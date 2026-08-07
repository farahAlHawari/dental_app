import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';

class ReportViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String title;
  final String planSessionLabel;
  final String date;

  const ReportViewerPage({
    super.key,
    required this.pdfUrl,
    required this.title,
    required this.planSessionLabel,
    required this.date,
  });

  @override
  State<ReportViewerPage> createState() => _ReportViewerPageState();
}

class _ReportViewerPageState extends State<ReportViewerPage> {
  bool _saving = false;

  Future<void> _downloadReport() async {
    if (_saving) return;
    final url = widget.pdfUrl.trim();
    if (url.isEmpty) {
      _snack('Failed to save report'.tr());
      return;
    }

    setState(() => _saving = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final reportsDir = Directory('${dir.path}/reports');
      if (!await reportsDir.exists()) {
        await reportsDir.create(recursive: true);
      }

      final fileName = _fileNameFromUrl(url);
      final path = '${reportsDir.path}/$fileName';

      await Dio().download(url, path);

      if (!await File(path).exists()) {
        throw Exception('file missing after download');
      }

      if (mounted) _snack('Report saved successfully'.tr());
    } catch (e) {
      if (mounted) {
        _snack('${'Failed to save report'.tr()}\n$e');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _fileNameFromUrl(String url) {
    try {
      final name = Uri.parse(url).pathSegments.lastWhere(
            (s) => s.trim().isNotEmpty,
            orElse: () => '',
          );
      if (name.toLowerCase().endsWith('.pdf')) return name;
    } catch (_) {}
    return 'report_${DateTime.now().millisecondsSinceEpoch}.pdf';
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = scheme.surface;
    final panel = scheme.surfaceContainerHighest;
    final onSurface = scheme.onSurface;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: onSurface,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            color: scheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _saving ? null : _downloadReport,
            icon: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: widget.pdfUrl.isEmpty
                  ? Center(child: Text('Failed to open report'.tr()))
                  : PdfViewer.uri(
                      Uri.parse(widget.pdfUrl),
                      params: PdfViewerParams(
                        backgroundColor: bg,
                      ),
                    ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: panel,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.planSessionLabel.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          color: scheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.planSessionLabel,
                            style: TextStyle(
                              color: onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: scheme.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.date,
                        style: TextStyle(
                          color: onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saving ? null : _downloadReport,
                      icon: const Icon(Icons.download),
                      label: Text('Download Report'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
