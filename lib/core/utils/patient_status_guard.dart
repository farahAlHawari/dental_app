import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Shared guard for patient lifecycle status (ACTIVE | ARCHIVED).
///
/// Use before any edit/action that must not run on archived patients:
/// ```dart
/// if (!PatientStatusGuard.ensureEditable(context, patient['status'])) return;
/// ```
class PatientStatusGuard {
  static const String active = 'ACTIVE';
  static const String archived = 'ARCHIVED';

  static String normalize(String? status) {
    final value = (status ?? active).trim().toUpperCase();
    if (value.isEmpty) return active;
    return value;
  }

  static bool isArchived(String? status) => normalize(status) == archived;

  static bool isActive(String? status) => normalize(status) == active;

  /// Returns true if the action is allowed.
  /// If archived: shows a SnackBar and returns false.
  static bool ensureEditable(
    BuildContext context,
    String? status, {
    String? message,
  }) {
    if (!isArchived(status)) return true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ??
              'This patient is archived and cannot be modified.'.tr(),
        ),
      ),
    );
    return false;
  }
}
