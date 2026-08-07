import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class RadiographViewerPage extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String planSessionLabel;
  final String date;

  const RadiographViewerPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.planSessionLabel,
    required this.date,
  });

  @override
  State<RadiographViewerPage> createState() => _RadiographViewerPageState();
}

class _RadiographViewerPageState extends State<RadiographViewerPage> {
  bool _saving = false;

  Future<void> _downloadImage() async {
    if (_saving) return;
    final url = widget.imageUrl.trim();
    if (url.isEmpty) {
      _snack('Failed to save image'.tr());
      return;
    }

    setState(() => _saving = true);
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          if (mounted) _snack('Gallery permission denied'.tr());
          return;
        }
      }

      final dir = await getTemporaryDirectory();
      final ext = _guessExt(url);
      final path =
          '${dir.path}/xray_${DateTime.now().millisecondsSinceEpoch}$ext';

      await Dio().download(url, path);
      await Gal.putImage(path);

      try {
        await File(path).delete();
      } catch (_) {}

      if (mounted) _snack('Image saved successfully'.tr());
    } catch (e) {
      if (mounted) {
        _snack('${'Failed to save image'.tr()}\n$e');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _guessExt(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('.png')) return '.png';
    if (lower.contains('.webp')) return '.webp';
    if (lower.contains('.gif')) return '.gif';
    return '.jpg';
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
            onPressed: _saving ? null : _downloadImage,
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
              child: PhotoView(
                imageProvider: NetworkImage(widget.imageUrl),
                backgroundDecoration: BoxDecoration(color: bg),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 4,
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(color: scheme.primary),
                ),
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: onSurface.withOpacity(0.4),
                  ),
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
                      onPressed: _saving ? null : _downloadImage,
                      icon: const Icon(Icons.download),
                      label: Text('Download Image'.tr()),
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
