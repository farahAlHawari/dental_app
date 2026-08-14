// lib/core/config/shared_prefs.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _langKey = 'app_language';
  static const String _themeModeKey = 'app_theme_mode';
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
  /// Brand splash (logo + phrase) — first launch only, like language/onboarding.
  static const String _hasSeenSplashKey = 'has_seen_splash';

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

  /// Device theme preference — not cleared on logout.
  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themeModeKey,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeModeKey);
    if (value == 'dark') return ThemeMode.dark;
    return ThemeMode.light;
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
  // Feature 7 — logout clears session tokens only
  // ================================
  /// Clears access + refresh tokens only.
  /// Keeps: selected_patient_id/status, app_language, app_theme_mode,
  /// has_seen_onboarding, has_seen_splash, biometric_enabled, user_phone,
  /// account_status, patient_onboarding_step.
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }
  // ================================
  // Feature 7 END
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

  /// Brand splash — not cleared on logout.
  static Future<void> setHasSeenSplash(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenSplashKey, seen);
  }

  static Future<bool> hasSeenSplash() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenSplashKey) ?? false;
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
