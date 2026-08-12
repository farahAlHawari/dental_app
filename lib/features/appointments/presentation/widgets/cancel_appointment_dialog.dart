import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// تأكيد إلغاء موعد مع حقل اختياري لسبب الإلغاء (cancellationReason).
class CancelAppointmentDialog extends StatefulWidget {
  const CancelAppointmentDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CancelAppointmentDialog(),
    );
  }

  @override
  State<CancelAppointmentDialog> createState() =>
      _CancelAppointmentDialogState();
}

class _CancelAppointmentDialogState extends State<CancelAppointmentDialog> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _confirm() {
    Navigator.pop(context, _reasonController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: colors.surface,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colors.error.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: colors.error,
                  size: 40,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Cancel this appointment?'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to cancel this appointment? This action cannot be undone.'
                    .tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.onSurface.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Cancellation reason (optional)'.tr(),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface.withOpacity(0.65),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: _reasonController,
                hint: 'Tell us why you are cancelling (optional)'.tr(),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: colors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Keep Appointment'.tr(),
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _confirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.error,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Yes, Cancel'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
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
      ),
    );
  }
}
