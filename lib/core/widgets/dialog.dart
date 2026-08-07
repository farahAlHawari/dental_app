import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum StatusDialogType {
  passwordChanged,
  passwordReset,
  phoneChanged,
  accountActivated,
}

class CustomStatusDialog extends StatelessWidget {
  final StatusDialogType type;
  final VoidCallback onConfirm;
  final String? cancelButtonText;
  final VoidCallback? onCancel;

  const CustomStatusDialog({
    super.key,
    required this.type,
    required this.onConfirm,
    this.cancelButtonText,
    this.onCancel,
  });

  static void show(
    BuildContext context, {
    required StatusDialogType type,
    required VoidCallback onConfirm,
    String? cancelButtonText,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomStatusDialog(
        type: type,
        onConfirm: onConfirm,
        cancelButtonText: cancelButtonText,
        onCancel: onCancel,
      ),
    );
  }

String get title {
  switch (type) {
    case StatusDialogType.passwordChanged:
      return "Password Changed Successfully".tr();

    case StatusDialogType.passwordReset:
      return "Password Reset Successfully".tr();

    case StatusDialogType.phoneChanged:
      return "Phone Number Updated".tr();

    case StatusDialogType.accountActivated:
      return "Account Activated Successfully".tr();
  }
}

String get description {
  switch (type) {
    case StatusDialogType.passwordChanged:
      return "Your password has been changed successfully.".tr();

    case StatusDialogType.passwordReset:
      return "Your password has been reset successfully. Please log in using your new password."
          .tr();

    case StatusDialogType.phoneChanged:
      return "Your phone number has been updated successfully.".tr();

    case StatusDialogType.accountActivated:
      return "Your account has been activated successfully. You can now log in with your new password."
          .tr();
  }
}

String get confirmButtonText {
  switch (type) {
    case StatusDialogType.passwordChanged:
      return "OK".tr();

    case StatusDialogType.phoneChanged:
      return "OK".tr();

    case StatusDialogType.passwordReset:
      return "Log In".tr();

    case StatusDialogType.accountActivated:
      return "Log In".tr();
  }
}

  String get animationPath {
    switch (type) {
      case StatusDialogType.passwordChanged:
      case StatusDialogType.passwordReset:
      case StatusDialogType.phoneChanged:
      case StatusDialogType.accountActivated:
        return "assets/animations/ss.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(
              animationPath,
              width: 120,
              height: 120,
              repeat: true,
            ),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                if (cancelButtonText != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel ?? () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        cancelButtonText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      confirmButtonText,
                      style: TextStyle(
                        color:
                            Theme.of(context).scaffoldBackgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}