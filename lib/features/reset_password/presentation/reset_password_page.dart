import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/core/widgets/dialog.dart';
import 'package:dental_app/features/login/presentation/pages/login_page.dart';
import 'package:dental_app/features/reset_password/presentation/bloc/reset_password_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  final String resetToken;

  const ResetPasswordPage({super.key, required this.resetToken});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    with SingleTickerProviderStateMixin {
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _toothController;

  @override
  void initState() {
    super.initState();
    _toothController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _toothController.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
             CustomStatusDialog.show(
  context,
  type: StatusDialogType.passwordReset,
  onConfirm: () {
    _goToLogin();
  },
);
            } else if (state is ResetPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errMessage)),
              );
            }
          },
          builder: (context, state) {
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface,
                                      borderRadius: BorderRadius.circular(28),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .shadow,
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Container(
                                            width: 60,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Center(
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/1.png",
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 100,
                                                ),
                                                AnimatedBuilder(
                                                  animation: _toothController,
                                                  builder: (context, child) {
                                                    final scale = 1 +
                                                        (_toothController
                                                                .value *
                                                            0.15);
                                                    return Transform.scale(
                                                      scale: scale,
                                                      child: child,
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    "assets/images/password.png",
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
                                            "Enter New Password".tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Center(
                                          child: Text(
                                            "Your new password must be different from previously used password."
                                                .tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.9),
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "New Password".tr(),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        AppTextField(
                                          controller: _password,
                                          hint: "••••••••",
                                          isPassword: true,
                                          prefixIcon: Icons.lock_outline,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "New password is required".tr();
                                                  
                                            }
                                            if (value.length < 8) {
                                              return "Password must be at least 8 characters"
                                                  .tr();
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "Confirm Password".tr(),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        AppTextField(
                                          controller: _confirmPassword,
                                          hint: "••••••••",
                                          isPassword: true,
                                          prefixIcon: Icons.lock_outline,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please confirm your new password"
                                                  .tr();
                                            }
                                            if (value != _password.text) {
                                              return "Passwords do not match"
                                                  .tr();
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 35),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 54,
                                          child: ElevatedButton(
                                            onPressed: state
                                                    is ResetPasswordLoading
                                                ? null
                                                : () {
                                                    if (!_formKey.currentState!
                                                        .validate()) {
                                                      return;
                                                    }
                                                    context
                                                        .read<
                                                            ResetPasswordBloc>()
                                                        .add(
                                                          ResetPasswordSubmitted(
                                                            resetToken: widget
                                                                .resetToken,
                                                            newPassword:
                                                                _password.text,
                                                            confirmPassword:
                                                                _confirmPassword
                                                                    .text,
                                                          ),
                                                        );
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: state
                                                    is ResetPasswordLoading
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Text(
                                                    "Save and change password"
                                                        .tr(),
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.background,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
