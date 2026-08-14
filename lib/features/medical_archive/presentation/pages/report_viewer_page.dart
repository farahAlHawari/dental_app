import 'dart:io';
import 'dart:typed_data';

import 'package:dental_app/core/utils/pdf_download_saver.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:photo_view/photo_view.dart';

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
  bool _loading = true;
  String? _localPath;
  bool _isImage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prepareFile());
  }

  Future<void> _prepareFile() async {
    final url = widget.pdfUrl.trim();
    if (url.isEmpty) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _localPath = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _localPath = null;
    });

    try {
      final dir = await getTemporaryDirectory();
      var fileName = _fileNameFromUrl(url);
      var path = '${dir.path}/$fileName';

      await Dio().download(
        url,
        path,
        options: Options(
          followRedirects: true,
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      final file = File(path);
      if (!await file.exists() || await file.length() == 0) {
        throw Exception('file missing after download');
      }

      final header = await _readHeader(file);
      final isImage = _headerLooksLikeImage(header);
      final isPdf = _headerLooksLikePdf(header);

      if (!isPdf && !isImage) {
        throw Exception('unsupported report file');
      }

      if (isImage && !fileName.contains('.')) {
        final renamed = '$path${_imageExtFromHeader(header)}';
        await file.rename(renamed);
        path = renamed;
      }

      if (!mounted) return;
      setState(() {
        _localPath = path;
        _isImage = isImage;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _localPath = null;
        _loading = false;
      });
    }
  }

  Future<void> _downloadReport() async {
    if (_saving) return;
    final path = _localPath;
    if (path == null) {
      _snack('Failed to save report'.tr());
      return;
    }

    setState(() => _saving = true);
    try {
      if (_isImage) {
        await _saveImageToGallery(path);
      } else {
        await _savePdfToDevice(path);
      }
    } catch (e) {
      if (mounted) {
        _snack('${'Failed to save report'.tr()}\n$e');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveImageToGallery(String path) async {
    final hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      final granted = await Gal.requestAccess();
      if (!granted) {
        if (mounted) _snack('Gallery permission denied'.tr());
        return;
      }
    }
    await Gal.putImage(path);
    if (mounted) _snack('Image saved successfully'.tr());
  }

  Future<void> _savePdfToDevice(String path) async {
    final bytes = await File(path).readAsBytes();
    await PdfDownloadSaver.save(
      fileName: _fileNameFromPath(path),
      bytes: bytes,
    );
    if (mounted) _snack('Report saved successfully'.tr());
  }

  Future<Uint8List> _readHeader(File file) async {
    final raf = await file.open();
    try {
      return await raf.read(8);
    } finally {
      await raf.close();
    }
  }

  bool _headerLooksLikePdf(Uint8List bytes) {
    if (bytes.length < 4) return false;
    return bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46;
  }

  bool _headerLooksLikeImage(Uint8List bytes) {
    if (bytes.length < 3) return false;
    final jpeg = bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF;
    final png =
        bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47;
    return jpeg || png;
  }

  String _imageExtFromHeader(Uint8List bytes) {
    if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return '.png';
    }
    return '.jpg';
  }

  String _fileNameFromUrl(String url) {
    try {
      final name = Uri.parse(
        url,
      ).pathSegments.lastWhere((s) => s.trim().isNotEmpty, orElse: () => '');
      if (name.isNotEmpty) return name;
    } catch (_) {}
    return 'report_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _fileNameFromPath(String path) {
    final parts = path.split(RegExp(r'[\\/]'));
    final name = parts.isEmpty ? '' : parts.last;
    if (name.trim().isNotEmpty) return name;
    return 'report_${DateTime.now().millisecondsSinceEpoch}.pdf';
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = scheme.surface;
    final panel = scheme.surfaceContainerHighest;
    final onSurface = scheme.onSurface;
    final canSave = !_saving && !_loading && _localPath != null;

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
            onPressed: canSave ? _downloadReport : null,
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
            Expanded(child: _buildPreview(scheme, bg, onSurface)),
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
                            style: TextStyle(color: onSurface.withOpacity(0.7)),
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
                        style: TextStyle(color: onSurface.withOpacity(0.7)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: canSave ? _downloadReport : null,
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

  Widget _buildPreview(ColorScheme scheme, Color bg, Color onSurface) {
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: scheme.primary));
    }

    final path = _localPath;
    if (path == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Failed to open report'.tr(), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _prepareFile,
                child: Text('Retry'.tr()),
              ),
            ],
          ),
        ),
      );
    }

    if (_isImage) {
      return PhotoView(
        imageProvider: FileImage(File(path)),
        backgroundDecoration: BoxDecoration(color: bg),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 4,
        errorBuilder: (_, __, ___) => Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: onSurface.withOpacity(0.4),
          ),
        ),
      );
    }

    return PdfViewer.file(path, params: PdfViewerParams(backgroundColor: bg));
  }
}
