// ================================
// NEW CODE START
// ================================

import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/utils/api_date_utils.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/features/register/presentation/widgets/birth_date_field.dart';
import 'package:dental_app/features/register/presentation/widgets/form_field_schema.dart';
import 'package:flutter/material.dart';

/// Reusable dynamic medical form field.
/// All field-type rendering lives here so pages never switch on type.
class DynamicFieldWidget extends StatefulWidget {
  final FormFieldSchema field;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const DynamicFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  @override
  State<DynamicFieldWidget> createState() => _DynamicFieldWidgetState();
}

class _DynamicFieldWidgetState extends State<DynamicFieldWidget> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: _valueAsText(widget.value),
    );
  }

  @override
  void didUpdateWidget(covariant DynamicFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _valueAsText(widget.value);
    if (_textController.text != next &&
        (widget.field.type == 'TEXT' ||
            widget.field.type == 'NUMBER' ||
            widget.field.type == 'TEXTAREA' ||
            widget.field.type == 'DATE')) {
      _textController.text = next;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _valueAsText(dynamic value) {
    if (value == null) return '';
    if (value is List) return value.join(', ');
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.required
              ? '${widget.field.label} *'
              : widget.field.label,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        _buildByType(context),
      ],
    );
  }

  Widget _buildByType(BuildContext context) {
    switch (widget.field.type.toUpperCase()) {
      case 'NUMBER':
        return AppTextField(
          controller: _textController,
          hint: widget.field.label,
          prefixIcon: Icons.numbers,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (v) {
            final parsed = num.tryParse(v);
            widget.onChanged(parsed ?? v);
          },
        );
      case 'DATE':
        return BirthDateField(
          controller: _textController,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              initialDate: DateTime.tryParse(_textController.text) ?? DateTime.now(),
            );
            if (date != null) {
              final formatted = ApiDateUtils.fromPicker(date);
              _textController.text = formatted;
              widget.onChanged(formatted);
            }
          },
        );
      case 'TEXTAREA':
        return AppTextField(
          controller: _textController,
          hint: widget.field.label,
          prefixIcon: Icons.notes,
          maxLines: 3,
          onChanged: widget.onChanged,
        );
      case 'RADIO':
        return _buildRadio(context);
      case 'MULTI_SELECT':
        return _buildMultiSelect(context);
      case 'TEXT':
        return AppTextField(
          controller: _textController,
          hint: widget.field.label,
          prefixIcon: Icons.edit_outlined,
          onChanged: widget.onChanged,
        );
      default:
        // Unsupported schema types are not editable.
        return AppTextField(
          controller: _textController,
          hint: widget.field.label,
          prefixIcon: Icons.edit_outlined,
          onChanged: widget.onChanged,
        );
    }
  }

  Widget _buildRadio(BuildContext context) {
    final selected = widget.value?.toString();
    return Column(
      children: widget.field.options.map((option) {
        final isSelected = selected == option.value;
        return GestureDetector(
          onTap: () => widget.onChanged(option.value),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultiSelect(BuildContext context) {
    final selected = <String>[];
    if (widget.value is List) {
      selected.addAll((widget.value as List).map((e) => e.toString()));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: widget.field.options.map((option) {
          final isSelected = selected.contains(option.value);
          return GestureDetector(
            onTap: () {
              final next = List<String>.from(selected);
              if (isSelected) {
                next.remove(option.value);
              } else {
                next.add(option.value);
              }
              widget.onChanged(next);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      option.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ================================
// NEW CODE END
// ================================
