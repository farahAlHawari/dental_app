import 'package:dental_app/features/promotional_gallery/data/models/app_content_type.dart';
import 'package:dental_app/features/promotional_gallery/data/models/content_media_file.dart';

class AppContentListResult {
  final List<AppContent> items;
  final int total;

  const AppContentListResult({required this.items, required this.total});
}

class AppContent {
  final String id;
  final AppContentType type;
  final String title;
  final String? body;
  final List<ContentMediaFile> mediaFiles;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppContent({
    required this.id,
    required this.type,
    required this.title,
    this.body,
    required this.mediaFiles,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppContent.fromJson(Map<String, dynamic> json) {
    final mediaRaw = json['mediaFiles'];
    final List<ContentMediaFile> media;
    if (mediaRaw is List) {
      media = mediaRaw
          .whereType<Map>()
          .map((e) => ContentMediaFile.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      media.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    } else {
      media = <ContentMediaFile>[];
    }

    final createdRaw = json['createdAt']?.toString();
    final updatedRaw = json['updatedAt']?.toString();
    final createdAt = DateTime.tryParse(createdRaw ?? '')?.toLocal() ??
        DateTime.now();
    final updatedAt = DateTime.tryParse(updatedRaw ?? '')?.toLocal() ??
        createdAt;

    return AppContent(
      id: '${json['id']}',
      type: AppContentType.fromApiValue(json['type']?.toString()),
      title: json['title']?.toString().trim() ?? '',
      body: json['body']?.toString().trim(),
      mediaFiles: media,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  bool get hasBody => body != null && body!.isNotEmpty;

  List<String> get imageUrls => mediaFiles
      .map((file) => file.resolvedUrl)
      .whereType<String>()
      .where((url) => url.isNotEmpty)
      .toList();
}
