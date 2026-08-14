import 'dart:ui' as ui;

import 'package:dental_app/features/promotional_gallery/data/models/app_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// كارد عرض محتوى من المعرض التسويقي — عرض فقط، بدون أي تفاعل.
class GalleryPostCard extends StatelessWidget {
  final AppContent content;

  const GalleryPostCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final imageUrls = content.imageUrls;
    final hasTitle = content.title.isNotEmpty;
    final hasBody = content.hasBody;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(isDark ? 0.30 : 0.10),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    content.type.icon,
                    size: 18,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Senni Clinic'.tr(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        content.type.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (imageUrls.isNotEmpty)
            AspectRatio(
              aspectRatio: 4 / 3,
              child: imageUrls.length == 1
                  ? _GalleryNetworkImage(url: imageUrls.first, colors: colors)
                  : _GalleryImagePager(urls: imageUrls, colors: colors),
            ),
          if (hasTitle || hasBody)
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasTitle)
                    Text(
                      content.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                        height: 1.35,
                      ),
                    ),
                  if (hasTitle && hasBody) const SizedBox(height: 8),
                  if (hasBody)
                    Text(
                      content.body!,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        color: colors.onSurface.withOpacity(0.8),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _GalleryNetworkImage extends StatelessWidget {
  final String url;
  final ColorScheme colors;

  const _GalleryNetworkImage({
    required this.url,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => _ImageFallback(colors: colors),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: colors.surfaceContainerHighest,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colors.primary,
          ),
        );
      },
    );
  }
}

class _GalleryImagePager extends StatefulWidget {
  final List<String> urls;
  final ColorScheme colors;

  const _GalleryImagePager({
    required this.urls,
    required this.colors,
  });

  @override
  State<_GalleryImagePager> createState() => _GalleryImagePagerState();
}

class _GalleryImagePagerState extends State<_GalleryImagePager> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          reverse: Directionality.of(context) == ui.TextDirection.rtl,
          itemCount: widget.urls.length,
          onPageChanged: (value) => setState(() => _index = value),
          itemBuilder: (context, index) => _GalleryNetworkImage(
            url: widget.urls[index],
            colors: widget.colors,
          ),
        ),
        if (widget.urls.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.urls.length, (index) {
                final active = index == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 8 : 6,
                  height: active ? 8 : 6,
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.white
                        : Colors.white.withOpacity(0.55),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final ColorScheme colors;

  const _ImageFallback({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 40,
        color: colors.onSurface.withOpacity(0.35),
      ),
    );
  }
}
