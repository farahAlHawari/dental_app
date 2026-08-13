import 'package:dental_app/core/utils/patient_profile_image.dart';

class SessionAttachment {
  final String id;
  final String type;
  final String? title;
  final String? publicUrl;
  final String? mimeType;
  final String? originalName;
  final DateTime? createdAt;

  const SessionAttachment({
    required this.id,
    required this.type,
    this.title,
    this.publicUrl,
    this.mimeType,
    this.originalName,
    this.createdAt,
  });

  factory SessionAttachment.fromJson(Map<String, dynamic> json) {
    final media = json['mediaFile'];
    final mediaMap = media is Map ? Map<String, dynamic>.from(media) : null;
    final createdRaw = json['createdAt']?.toString();

    return SessionAttachment(
      id: '${json['id']}',
      type: json['type']?.toString().toUpperCase() ?? '',
      title: json['title']?.toString().trim(),
      publicUrl: PatientProfileImage.resolve(
        mediaMap?['publicUrl']?.toString(),
      ),
      mimeType: mediaMap?['mimeType']?.toString(),
      originalName: mediaMap?['originalName']?.toString(),
      createdAt: DateTime.tryParse(createdRaw ?? '')?.toLocal(),
    );
  }

  bool get isImage {
    final mime = mimeType?.toLowerCase() ?? '';
    if (mime.startsWith('image/')) return true;
    return type == 'XRAY' || type == 'PHOTO';
  }

  bool get isPdf {
    final mime = mimeType?.toLowerCase() ?? '';
    final name = (originalName ?? publicUrl ?? '').toLowerCase();
    if (mime.contains('pdf') || name.endsWith('.pdf')) return true;
    return type == 'REPORT';
  }

  String get typeLabelKey {
    switch (type) {
      case 'XRAY':
        return 'Radiograph';
      case 'REPORT':
        return 'Report';
      case 'PHOTO':
        return 'Photo';
      default:
        return 'Attachment';
    }
  }
}

class SessionEncounter {
  final String? diagnosis;
  final String? clinicalNotes;
  final String? prescription;
  final List<SessionAttachment> attachments;

  const SessionEncounter({
    this.diagnosis,
    this.clinicalNotes,
    this.prescription,
    this.attachments = const [],
  });

  factory SessionEncounter.fromJson(Map<String, dynamic> json) {
    final raw = json['attachments'];
    final attachments = <SessionAttachment>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          attachments.add(SessionAttachment.fromJson(item));
        } else if (item is Map) {
          attachments.add(
            SessionAttachment.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    return SessionEncounter(
      diagnosis: _text(json['diagnosis']),
      clinicalNotes: _text(json['clinicalNotes']),
      prescription: _text(json['prescription']),
      attachments: attachments,
    );
  }

  static String? _text(dynamic value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }

  bool get hasTextContent =>
      diagnosis != null || clinicalNotes != null || prescription != null;

  bool get hasAttachments => attachments.isNotEmpty;

  bool get hasAnything => hasTextContent || hasAttachments;

  List<SessionAttachment> attachmentsOf(String type) =>
      attachments.where((a) => a.type == type).toList();
}
