import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/utils/patient_status_guard.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/home_page.dart';
import 'package:dental_app/features/login/presentation/pages/login_page.dart';
import 'package:dental_app/features/profile/data/datasources/patient_remote_data_source.dart';
import 'package:dental_app/features/profile/domain/repositories/patient_repository_impl.dart';
import 'package:dental_app/features/register/presentation/pages/patient_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Single post-auth entry point.
///
/// - No patients → PatientType (never restore a stale onboarding step)
/// - Has patients → HomePage (restore selected patient when still valid)
/// - Network / server failure → no navigation (caller shows retry)
/// - 401 after refresh fail → Login (tokens already cleared by Dio)
class PostAuthNavigation {
  /// Returns `true` if a destination was opened; `false` if the caller should
  /// keep the current screen and offer retry (network / 5xx).
  static Future<bool> go(BuildContext context) async {
    final repository = PatientRepositoryImpl(
      remoteDataSource: PatientRemoteDataSource(api: DioConsumer(dio: Dio())),
    );

    final result = await repository.getMyPatients();
    if (!context.mounted) return true;

    return await result.fold(
      (failure) async {
        final statusCode = failure.statusCode;

        // ================================
        // MODIFIED — network / server: do not treat as empty list
        // ================================
        if (statusCode == null ||
            statusCode == 0 ||
            statusCode >= 500) {
          return false;
        }

        // Unauthorized after refresh failure (Dio already cleared tokens).
        if (statusCode == 401) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
          return true;
        }

        // Other client errors: stay put for retry (do not open PatientType).
        return false;
      },
      (patients) async {
        if (patients.isEmpty) {
          await _goPatientType(context);
          return true;
        }

        await _restoreSelectedPatient(patients);
        await SharedPrefs.savePatientOnboardingStep(
          SharedPrefs.onboardingComplete,
        );
        if (!context.mounted) return true;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
        return true;
      },
    );
  }

  static Future<void> _goPatientType(BuildContext context) async {
    await SharedPrefs.savePatientOnboardingStep(
      SharedPrefs.onboardingPatientType,
    );
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const PatientType()),
      (route) => false,
    );
  }

  static Future<void> _restoreSelectedPatient(
    List<Map<String, dynamic>> patients,
  ) async {
    final savedId = await SharedPrefs.getSelectedPatientId();

    Map<String, dynamic>? selected;
    if (savedId != null && savedId.isNotEmpty) {
      for (final p in patients) {
        final id = (p['id'] ?? p['_id'] ?? '').toString();
        if (id == savedId) {
          selected = p;
          break;
        }
      }
    }

        selected ??= () {
          for (final p in patients) {
            if (PatientStatusGuard.isActive(p['status']?.toString())) {
              return p;
            }
          }
          return null;
        }();

        selected ??= patients.isNotEmpty ? patients.first : null;
    if (selected == null) return;

    final id = (selected['id'] ?? selected['_id'] ?? '').toString();
    final status = PatientStatusGuard.normalize(selected['status']?.toString());
    if (id.isNotEmpty) {
      await SharedPrefs.saveSelectedPatientId(id);
    }
    await SharedPrefs.saveSelectedPatientStatus(status);
  }
}
