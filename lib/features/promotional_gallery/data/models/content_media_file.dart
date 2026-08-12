import 'package:dental_app/core/utils/patient_profile_image.dart';

class ContentMediaFile {
  final String id;
  final String mediaFileId;
  final int displayOrder;
  final String originalName;
  final String mimeType;
  final String url;

  const ContentMediaFile({
    required this.id,
    required this.mediaFileId,
    required this.displayOrder,
    required this.originalName,
    required this.mimeType,
    required this.url,
  });

  factory ContentMediaFile.fromJson(Map<String, dynamic> json) {
    return ContentMediaFile(
      id: '${json['id']}',
      mediaFileId: '${json['mediaFileId']}',
      displayOrder: json['displayOrder'] is int
          ? json['displayOrder'] as int
          : int.tryParse('${json['displayOrder']}') ?? 0,
      originalName: json['originalName']?.toString() ?? '',
      mimeType: json['mimeType']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  String? get resolvedUrl => PatientProfileImage.resolve(url);
}
