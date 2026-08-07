import 'dart:async';

import 'package:dental_app/core/navigation/post_auth_navigation.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/dialog.dart';
import 'package:dental_app/core/widgets/masked_phone_chip.dart';
import 'package:dental_app/features/Verify_otp/presentation/bloc/verify_otp_bloc.dart';
import 'package:dental_app/features/Verify_otp/presentation/pages/otp_flow.dart';
import 'package:dental_app/features/account_settings/presentation/pages/account_settings.dart';
import 'package:dental_app/features/reset_password/presentation/reset_password_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class VerifyOtpPage extends StatefulWidget {
  final String phone;
  final OtpFlow flow;
  final Future<bool> Function() onResend;

  const VerifyOtpPage({
    super.key,
    required this.phone,
    required this.flow,
    required this.onResend,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage>
    with SingleTickerProviderStateMixin {
  final _otpController = TextEditingController();

  static const int _maxAttempts = 5;
  static const int _timerSeconds = 300; // 5 دقايق

  int _seconds = _timerSeconds;
  int _attempts = 0;
  bool _resending = false;
  Timer? _timer;

  late AnimationController _toothController;

  void _startTimer() {
    _seconds = _timerSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  String _formatTimer(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _handleResend() async {
    if (_resending) return;
    setState(() => _resending = true);
    bool success = await widget.onResend();
    setState(() => _resending = false);

    if (success) {
      setState(() => _attempts = 0);
      _startTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("unenabled to resend code".tr())),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    _toothController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // بتتحرك رايح جاي بشكل مستمر
  }

  @override
  void dispose() {
    _toothController.dispose(); // لازم تعمليها dispose
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyOtpBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        body: BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
          listener: (context, state) async {
            if (state is VerifyOtpSuccess) {
              switch (widget.flow) {
                case OtpFlow.register:
                  // After OTP: no patients → PatientType (force create);
                  // has patients → Profile. Same gate as post-login.
                  if (!context.mounted) return;
                  await PostAuthNavigation.go(context);
                  break;
                case OtpFlow.forgotPassword:
                  final token = state.resetToken;
                  if (token != null && token.isNotEmpty) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResetPasswordPage(resetToken: token),
                      ),
                    );
                  }
                  // Already verified / no resetToken: stay on page, no crash.
                  break;
                case OtpFlow.changePhone:
                CustomStatusDialog.show(
  context,
  type: StatusDialogType.phoneChanged,
  onConfirm: () {
    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => AccountSettings()
    ),
    (route) => false,
  );
  },
);
               
                  break;
              }
            } else if (state is VerifyOtpFailure) {
              final needle =
                  '${state.failureMessage} ${state.errorCode ?? ''}'.toUpperCase();
              setState(() {
                _attempts++;
                if (needle.contains('OTP_MAX_ATTEMPTS')) {
                  _attempts = _maxAttempts;
                }
                if (needle.contains('OTP_EXPIRED')) {
                  _seconds = 0;
                  _timer?.cancel();
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.failureMessage)),
              );
            }
          },
          builder: (context, state) {
            final bool isLocked = _attempts >= _maxAttempts;
            return SizedBox.expand(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/backgrounds/background1.png',
                      color: Theme.of(context).colorScheme.primary,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SafeArea(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 24),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.shadow,
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 60,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primary,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Center(
                                      child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/1.png",
                                              color: Theme.of(context).colorScheme.primary,
                                              width: 100,
                                            ),
                                            AnimatedBuilder(
                                              animation: _toothController,
                                              builder: (context, child) {
                                                final scale =
                                                    1 + (_toothController.value * 0.15);
                                                return Transform.scale(
                                                  scale: scale,
                                                  child: child,
                                                );
                                              },
                                              child: Image.asset(
                                                "assets/images/4.png",
                                                width: 45,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "Verify OTP".tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    // ================================
                                    // MODIFIED — Change Phone: masked destination phone
                                    // ================================
                                    if (widget.flow == OtpFlow.changePhone) ...[
                                      const SizedBox(height: 12),
                                      MaskedPhoneChip(
                                        label: "Verification code sent to".tr(),
                                        phone: widget.phone,
                                      ),
                                    ] else
                                      Center(
                                        child: Text(
                                          "Enter the verification code sent to your mobile number"
                                              .tr(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.7),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    // ================================
                                    // MODIFIED END
                                    // ================================
                                    const SizedBox(height: 30),
                                    Center(
                                      child: Pinput(
                                        controller: _otpController,
                                        length: 6,
                                        defaultPinTheme: PinTheme(
                                          width: 50,
                                          height: 56,
                                          textStyle: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 225, 236, 240),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                        focusedPinTheme: PinTheme(
                                          width: 50,
                                          height: 56,
                                          textStyle: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 225, 236, 240),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Theme.of(context).colorScheme.primary,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    Center(
                                      child: Text(
                                        "Didn't receive the code?".tr(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.7),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Center(
                                      child: _seconds == 0
                                          ? TextButton(
                                              onPressed:
                                                  _resending ? null : _handleResend,
                                              child: _resending
                                                  ? const SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                  : Text(
                                                      "Resend Code".tr(),
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                            )
                                          : Text(
                                              'Resend in {time}'.tr(
                                                namedArgs: {
                                                  'time': _formatTimer(_seconds),
                                                },
                                              ),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(height: 35),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 54,
                                      child: ElevatedButton(
                                        onPressed: (state is VerifyOtpLoading || isLocked)
                                            ? null
                                            : () {
                                                context.read<VerifyOtpBloc>().add(
                                                      VerifyOtpSubmitted(
                                                        phone: widget.phone,
                                                        code: _otpController.text,
                                                        // ================================
                                                        // NEW CODE START
                                                        // ================================
                                                        flow: widget.flow,
                                                        // ================================
                                                        // NEW CODE END
                                                        // ================================
                                                      ),
                                                    );
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isLocked
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.3)
                                              : Theme.of(context).colorScheme.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            state is VerifyOtpLoading
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Text(
                                                    isLocked
                                                        ? "Max attempts reached,\nrequest a new code"
                                                            .tr()
                                                        : "Verify".tr(),
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}