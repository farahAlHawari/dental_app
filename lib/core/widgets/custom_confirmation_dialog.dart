import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmButtonText;
  final VoidCallback onConfirm;
  final String? cancelButtonText;
  final VoidCallback? onCancel;

  /// true لحالات التحذير/الإجراءات اللي بترجع لورا (متل تأكيد إلغاء
  /// موعد) - بيستبدل أنيميشن الاحتفال (confetti) بأيقونة تحذير بلون
  /// error، لأنه مش منطقي نحتفل بإجراء المريض عم يفكر يلغي شي.
  final bool isDestructive;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmButtonText,
    required this.onConfirm,
    this.cancelButtonText,
    this.onCancel,
    this.isDestructive = false,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String description,
    required String confirmButtonText,
    required VoidCallback onConfirm,
    String? cancelButtonText,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomConfirmationDialog(
        title: title,
        description: description,
        confirmButtonText: confirmButtonText,
        onConfirm: onConfirm,
        cancelButtonText: cancelButtonText,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
    );
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
            if (isDestructive)
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 46,
                ),
              )
            else
              LottieBuilder.asset(
                "assets/animations/ss.json",
                width: 120,
                height: 120,
                repeat: true,
              ),
            const SizedBox(height: 12),

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
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      confirmButtonText,
                      style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor,
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