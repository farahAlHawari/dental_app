import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/register/presentation/widgets/form_field_schema.dart';

class PatientInfoView extends StatelessWidget {
  final String name;
  final String dob;
  final String gender;
  final ImageProvider? avatarImage;
  final VoidCallback onEditPressed;

  final List<FormFieldSchema> schema;
  final Map<String, dynamic> formValues;

  const PatientInfoView({
    super.key,
    required this.name,
    required this.dob,
    required this.gender,
    this.diseases = const [],
    this.allergies = '',
    required this.avatarImage,
    required this.onEditPressed,
    this.schema = const [],
    this.formValues = const {},
  });

  /// Kept for backward compatibility with existing callers.
  final List<String> diseases;
  final String allergies;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: primary.withOpacity(0.15),
                backgroundImage: avatarImage,
                child: avatarImage == null
                    ? Icon(Icons.person, size: 50, color: primary)
                    : null,
              ),
              const SizedBox(height: 14),
              Text(
                name.isEmpty ? "Unnamed Patient".tr() : name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
              ),
              const SizedBox(height: 6),
              _genderChip(primary),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Divider(color: onSurface.withOpacity(0.1)),
        const SizedBox(height: 10),
        _infoRow(
          context,
          icon: Icons.cake_outlined,
          label: "Birth Date".tr(),
          value: dob.isEmpty ? "-" : dob,
        ),
        const SizedBox(height: 18),
        if (schema.isNotEmpty)
          ...schema.map(
            (field) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: _infoRow(
                context,
                icon: Icons.medical_information_outlined,
                label: field.label,
                value: formatDynamicFieldValue(field, formValues[field.key]),
              ),
            ),
          )
        else ...[
          _diseasesSection(context, primary, onSurface),
          const SizedBox(height: 20),
          _infoRow(
            context,
            icon: Icons.medical_information_outlined,
            label: "Allergies".tr(),
            value: allergies.isEmpty
                ? "No known allergies".tr()
                : allergies,
          ),
        ],
        const SizedBox(height: 26),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: onEditPressed,
            icon: Icon(Icons.edit_outlined, color: primary),
            label: Text(
              "Edit Information".tr(),
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _genderChip(Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            gender.toLowerCase() == "male" ? Icons.male : Icons.female,
            size: 16,
            color: primary,
          ),
          const SizedBox(width: 4),
          Text(
            gender.isEmpty ? "-" : gender.tr(),
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _diseasesSection(
    BuildContext context,
    Color primary,
    Color onSurface,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.medical_services_outlined, size: 18, color: primary),
            const SizedBox(width: 8),
            Text(
              "Chronic Diseases".tr(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        diseases.isEmpty
            ? Text(
                "No chronic diseases reported".tr(),
                style: TextStyle(
                  fontSize: 13,
                  color: onSurface.withOpacity(0.5),
                ),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: diseases
                    .map(
                      (d) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          d,
                          style: TextStyle(
                            fontSize: 12,
                            color: primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ],
    );
  }

  Widget _infoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final primary = AppColors.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 14, color: onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
