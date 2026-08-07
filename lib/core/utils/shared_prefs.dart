// lib/core/config/shared_prefs.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _langKey = 'app_language';
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _selectedPatientIdKey = 'selected_patient_id';
  static const String _selectedPatientStatusKey = 'selected_patient_status';
  static const String _phoneKey = 'user_phone';
  static const String _accountStatusKey = 'account_status';
  static const String _patientOnboardingStepKey = 'patient_onboarding_step';
  /// Marketing slides only (not patient Type/Medical form).
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  /// Onboarding steps after register OTP (patient flow — separate).
  static const String onboardingPatientType = 'patient_type';
  static const String onboardingMedicalForm = 'medical_form';
  static const String onboardingComplete = 'complete';

  static Future<void> saveLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, code);
  }

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_langKey);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // ================================
  // MODIFIED — session cleanup: access + refresh only (Feature 5)
  // ================================
  /// Clears authentication tokens only.
  /// Keeps selected patient, onboarding step, language, marketing flag,
  /// biometric, phone, and other local preferences.
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }
  // ================================
  // MODIFIED END
  // ================================

  static Future<void> saveBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
  }

  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  static Future<void> saveSelectedPatientId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedPatientIdKey, id);
  }

  static Future<String?> getSelectedPatientId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedPatientIdKey);
  }

  static Future<void> saveSelectedPatientStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedPatientStatusKey, status);
  }

  static Future<String?> getSelectedPatientStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedPatientStatusKey);
  }

  static Future<void> savePhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneKey, phone);
  }

  static Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneKey);
  }

  static Future<void> saveAccountStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accountStatusKey, status);
  }

  static Future<String?> getAccountStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accountStatusKey);
  }

  static Future<void> savePatientOnboardingStep(String step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_patientOnboardingStepKey, step);
  }

  static Future<String?> getPatientOnboardingStep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_patientOnboardingStepKey);
  }

  /// Marketing onboarding — not cleared on logout.
  static Future<void> setHasSeenOnboarding(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, seen);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  /// Masks phone for display, e.g. 0912345678 -> 0912••••78
  static String maskPhone(String? phone) {
    final p = (phone ?? '').trim();
    if (p.length < 6) return p;
    final start = p.substring(0, 4);
    final end = p.substring(p.length - 2);
    return '$start••••$end';
  }
}
