import 'package:dental_app/features/treatment_plans/data/models/session_encounter.dart';

enum PlanFileKind {
  reports,
  prescriptions,
  radiographs,
  beforeAfter;

  String get apiType {
    switch (this) {
      case PlanFileKind.reports:
        return 'REPORT';
      case PlanFileKind.prescriptions:
        return 'PRESCRIPTION';
      case PlanFileKind.radiographs:
        return 'XRAY';
      case PlanFileKind.beforeAfter:
        return 'PHOTO';
    }
  }

  String get titleKey {
    switch (this) {
      case PlanFileKind.reports:
        return 'Reports';
      case PlanFileKind.prescriptions:
        return 'Prescriptions';
      case PlanFileKind.radiographs:
        return 'Radiographs';
      case PlanFileKind.beforeAfter:
        return 'Before and After';
    }
  }

  String get emptyMessageKey {
    switch (this) {
      case PlanFileKind.reports:
        return 'No reports';
      case PlanFileKind.prescriptions:
        return 'No prescriptions';
      case PlanFileKind.radiographs:
        return 'No radiographs';
      case PlanFileKind.beforeAfter:
        return 'No before and after photos';
    }
  }
}

class PlanSessionFiles {
  final String id;
  final int sessionOrder;
  final String title;
  final String? prescription;
  final List<SessionAttachment> attachments;

  const PlanSessionFiles({
    required this.id,
    required this.sessionOrder,
    required this.title,
    this.prescription,
    this.attachments = const [],
  });

  factory PlanSessionFiles.fromJson(Map<String, dynamic> json) {
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

    final prescription = json['prescription']?.toString().trim();
    return PlanSessionFiles(
      id: '${json['id']}',
      sessionOrder: json['sessionOrder'] is int
          ? json['sessionOrder'] as int
          : int.tryParse('${json['sessionOrder']}') ?? 0,
      title: json['title']?.toString().trim() ?? '',
      prescription:
          (prescription == null || prescription.isEmpty) ? null : prescription,
      attachments: attachments,
    );
  }

  String get sessionLabel => title;
}

class PlanFileItem {
  final PlanSessionFiles session;
  final SessionAttachment attachment;

  const PlanFileItem({required this.session, required this.attachment});

  String get sessionLabel => session.sessionLabel;
  DateTime? get createdAt => attachment.createdAt;
}

class PlanPrescriptionItem {
  final PlanSessionFiles session;

  const PlanPrescriptionItem({required this.session});

  String get sessionLabel => session.sessionLabel;
  String get text => session.prescription ?? '';
}

class PlanPhotoPair {
  final PlanSessionFiles session;
  final SessionAttachment before;
  final SessionAttachment after;

  const PlanPhotoPair({
    required this.session,
    required this.before,
    required this.after,
  });

  String get sessionLabel => session.sessionLabel;
  DateTime? get createdAt => after.createdAt ?? before.createdAt;
}

class SessionPhotoPair {
  final SessionAttachment before;
  final SessionAttachment after;

  const SessionPhotoPair({required this.before, required this.after});

  DateTime? get createdAt => after.createdAt ?? before.createdAt;
}

class PlanSessionFilesMapper {
  PlanSessionFilesMapper._();

  static List<PlanFileItem> flattenAttachments(
    List<PlanSessionFiles> sessions, {
    required String type,
  }) {
    final items = <PlanFileItem>[];
    for (final session in sessions) {
      for (final attachment in session.attachments) {
        if (attachment.type == type) {
          items.add(PlanFileItem(session: session, attachment: attachment));
        }
      }
    }
    items.sort((a, b) {
      final ac = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bc = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bc.compareTo(ac);
    });
    return items;
  }

  static List<PlanPrescriptionItem> prescriptions(
    List<PlanSessionFiles> sessions,
  ) {
    final items = <PlanPrescriptionItem>[];
    for (final session in sessions) {
      if (session.prescription != null && session.prescription!.isNotEmpty) {
        items.add(PlanPrescriptionItem(session: session));
      }
    }
    items.sort((a, b) => b.session.sessionOrder.compareTo(a.session.sessionOrder));
    return items;
  }

  static List<PlanPhotoPair> photoPairs(List<PlanSessionFiles> sessions) {
    final pairs = <PlanPhotoPair>[];
    for (final session in sessions) {
      final pair = _pairPhotos(session);
      if (pair != null) pairs.add(pair);
    }
    pairs.sort((a, b) {
      final ac = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bc = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bc.compareTo(ac);
    });
    return pairs;
  }

  static SessionPhotoPair? pairPhotoAttachments(
    List<SessionAttachment> attachments,
  ) {
    final photos =
        attachments.where((a) => a.type == 'PHOTO').toList();
    if (photos.length < 2) return null;

    SessionAttachment? before;
    SessionAttachment? after;
    for (final photo in photos) {
      if (_isBeforeTitle(photo.title)) {
        before = photo;
      } else if (_isAfterTitle(photo.title)) {
        after = photo;
      }
    }
    if (before != null && after != null) {
      return SessionPhotoPair(before: before, after: after);
    }

    photos.sort((a, b) {
      final ac = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bc = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return ac.compareTo(bc);
    });
    return SessionPhotoPair(before: photos.first, after: photos[1]);
  }

  static PlanPhotoPair? _pairPhotos(PlanSessionFiles session) {
    final pair = pairPhotoAttachments(session.attachments);
    if (pair == null) return null;
    return PlanPhotoPair(
      session: session,
      before: pair.before,
      after: pair.after,
    );
  }

  static bool _isBeforeTitle(String? title) {
    final value = title?.toLowerCase().trim() ?? '';
    return value.contains('قبل') || value.contains('before');
  }

  static bool _isAfterTitle(String? title) {
    final value = title?.toLowerCase().trim() ?? '';
    return value.contains('بعد') || value.contains('after');
  }
}
