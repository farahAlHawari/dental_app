import 'package:dental_app/core/navigation/post_auth_navigation.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/core/widgets/dialog.dart';
import 'package:dental_app/features/complete_activation/presentation/bloc/complete_activation_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteActivationPage extends StatefulWidget {
  final String temporaryToken;

  const CompleteActivationPage({
    super.key,
    required this.temporaryToken,
  });

  @override
  State<CompleteActivationPage> createState() => _CompleteActivationPageState();
}

class _CompleteActivationPageState extends State<CompleteActivationPage>
    with SingleTickerProviderStateMixin {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _toothController.dispose();
    super.dispose();
  }

  Future<void> _goToHome() async {
    await PostAuthNavigation.go(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompleteActivationBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        body: BlocConsumer<CompleteActivationBloc, CompleteActivationState>(
          listener: (context, state) {
            if (state is CompleteActivationSuccess) {
              CustomStatusDialog.show(
  context,
  type: StatusDialogType.accountActivated,
  onConfirm: () {
    _goToHome();
  },
);
              
            } else if (state is CompleteActivationFailure) {
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
                                            "Complete Activation".tr(),
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
                                            "Enter your new password".tr(),
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
                                          controller: _newPasswordController,
                                          hint: "••••••••",
                                          isPassword: true,
                                          prefixIcon: Icons.lock_outline,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "New password is required"
                                                  .tr();
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
                                          "Confirm New Password".tr(),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        AppTextField(
                                          controller:
                                              _confirmPasswordController,
                                          hint: "••••••••",
                                          isPassword: true,
                                          prefixIcon: Icons.lock_outline,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please confirm your new password"
                                                  .tr();
                                            }
                                            if (value !=
                                                _newPasswordController.text) {
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
                                                    is CompleteActivationLoading
                                                ? null
                                                : () {
                                                    if (!_formKey.currentState!
                                                        .validate()) {
                                                      return;
                                                    }
                                                    context
                                                        .read<
                                                            CompleteActivationBloc>()
                                                        .add(
                                                          CompleteActivationSubmitted(
                                                            temporaryToken: widget
                                                                .temporaryToken,
                                                            newPassword:
                                                                _newPasswordController
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
                                            child: state is CompleteActivationLoading
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
                                                    "Activate Account".tr(),
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                          ),
                                        ),
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
