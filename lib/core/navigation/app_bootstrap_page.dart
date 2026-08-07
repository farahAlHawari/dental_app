import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/navigation/post_auth_navigation.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/change_language/presentation/pages/choose_language.dart';
import 'package:dental_app/features/login/data/datasources/login_data_source.dart';
import 'package:dental_app/features/login/domain/repositories/login_repository_impl.dart';
import 'package:dental_app/features/login/presentation/pages/login_page.dart';
import 'package:dental_app/features/onboarding/presentation/pages/on_boarding_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// App entry host: Splash UI + Bootstrap decision point.
///
/// Startup chain (filled feature-by-feature):
/// Splash → Language check → Marketing onboarding → Session → PostAuthNavigation
class AppBootstrapPage extends StatefulWidget {
  const AppBootstrapPage({super.key});

  @override
  State<AppBootstrapPage> createState() => _AppBootstrapPageState();
}

class _AppBootstrapPageState extends State<AppBootstrapPage> {
  bool _navigated = false;

  // ================================
  // NEW CODE START
  // ================================
  String? _sessionErrorMessage;
  // ================================
  // NEW CODE END
  // ================================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runBootstrap();
    });
  }

  /// Single startup decision point. Do not duplicate this chain elsewhere.
  Future<void> _runBootstrap() async {
    await Future.delayed(const Duration(seconds: 3));
    if (_navigated || !mounted) return;

    // --- Language check (Feature 2) ---
    // Reuses existing app_language only — no duplicate language flags.
    final language = await SharedPrefs.getLanguage();
    final hasLanguage = language != null && language.trim().isNotEmpty;
    if (!hasLanguage) {
      _goTo(const ChooseLanguage());
      return;
    }

    // --- Marketing onboarding check (Feature 3) ---
    // Separate from patient_onboarding_step (Patient Type / Medical Info).
    final seenMarketing = await SharedPrefs.hasSeenOnboarding();
    if (!seenMarketing) {
      _goTo(const OnboardingPage());
      return;
    }

    // Session validation (Feature 4) + restore destination (Feature 5).
    await _validateSessionAndNavigate();
  }

  // ================================
  // NEW CODE START
  // ================================
  Future<void> _validateSessionAndNavigate() async {
    final accessToken = await SharedPrefs.getToken();
    final hasAccessToken =
        accessToken != null && accessToken.trim().isNotEmpty;

    // No access token → Login (do not call auth/me).
    if (!hasAccessToken) {
      _goTo(const LoginPage());
      return;
    }

    final repository = LoginRepositoryImpl(
      loginDataSource: LoginDataSource(api: DioConsumer(dio: Dio())),
    );

    final result = await repository.getMe();
    if (!mounted || _navigated) return;

    await result.fold(
      (failure) async {
        final statusCode = failure.statusCode;
        final message = failure.errMessage;

        // Network / no response / server errors: keep tokens, stay safe.
        if (statusCode == null ||
            statusCode == 0 ||
            statusCode >= 500) {
          _showSessionError(
            message.isNotEmpty
                ? message
                : 'Unable to verify session. Please try again.'.tr(),
          );
          return;
        }

        // 401 account / session invalid cases from backend.
        if (statusCode == 401) {
          // ================================
          // MODIFIED — Feature 5: unified clearTokens()
          // ================================
          await SharedPrefs.clearTokens();
          if (!mounted) return;
          _goToLoginWithMessage(message);
          return;
        }

        // Other client errors: do not clear tokens; stay on splash safely.
        _showSessionError(
          message.isNotEmpty
              ? message
              : 'Unable to verify session. Please try again.'.tr(),
        );
      },
      (data) async {
        final accountStatus =
            (data['accountStatus']?.toString() ?? '').toUpperCase();

        // ================================
        // MODIFIED — Feature 5: ACTIVE → PostAuthNavigation
        // ================================
        if (accountStatus == 'ACTIVE') {
          if (_navigated || !mounted) return;
          final navigated = await PostAuthNavigation.go(context);
          if (!mounted) return;
          if (!navigated) {
            // patients/my network/server failure — session still valid.
            _showSessionError(
              'Unable to connect to the server. Please try again.'.tr(),
            );
            return;
          }
          _navigated = true;
          return;
        }

        // Unexpected 200 shape (safety): Login without clearing tokens.
        _goTo(const LoginPage());
      },
    );
  }

  void _goToLoginWithMessage(String message) {
    final display = message.trim().isNotEmpty
        ? message
        : 'Session expired. Please log in again.'.tr();

    if (!mounted) return;
    // Show on root messenger so the message survives pushReplacement → Login.
    final messenger = ScaffoldMessenger.of(context);
    _goTo(const LoginPage());
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(display)));
  }

  void _showSessionError(String message) {
    if (!mounted || _navigated) return;
    setState(() => _sessionErrorMessage = message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _retrySessionValidation() async {
    if (_navigated) return;
    setState(() => _sessionErrorMessage = null);
    await _validateSessionAndNavigate();
  }
  // ================================
  // NEW CODE END
  // ================================

  void _goTo(Widget page) {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      // ================================
      // MODIFIED START
      // ================================
      body: Center(
        child: _sessionErrorMessage == null
            ? Lottie.asset(
                'assets/animations/load.json',
                width: 180,
                repeat: true,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _sessionErrorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retrySessionValidation,
                      child: Text('Retry'.tr()),
                    ),
                  ],
                ),
              ),
      ),
      // ================================
      // MODIFIED END
      // ================================
    );
  }
}
