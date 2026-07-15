import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:dental_app/core/theme/app_colors.dart';


class BirthDateField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const BirthDateField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hint: "Birth Date",
      prefixIcon: Icons.calendar_today,
      readOnly: true,
      onTap: onTap,
    );
  }
}