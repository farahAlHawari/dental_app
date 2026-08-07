// ================================
// NEW CODE START
// ================================

class FormFieldOption {
  final String value;
  final String label;

  FormFieldOption({
    required this.value,
    required this.label,
  });

  factory FormFieldOption.fromJson(dynamic json) {
    if (json is String) {
      return FormFieldOption(value: json, label: json);
    }
    final map = json as Map<String, dynamic>;
    return FormFieldOption(
      value: (map['value'] ?? map['key'] ?? map['id'] ?? '').toString(),
      label: (map['label'] ?? map['name'] ?? map['value'] ?? '').toString(),
    );
  }
}

class FormFieldSchema {
  final String key;
  final String label;
  final String type;
  final bool required;
  final Map<String, dynamic>? validation;
  final List<FormFieldOption> options;

  FormFieldSchema({
    required this.key,
    required this.label,
    required this.type,
    required this.required,
    this.validation,
    this.options = const [],
  });

  factory FormFieldSchema.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    final options = <FormFieldOption>[];
    if (rawOptions is List) {
      for (final item in rawOptions) {
        options.add(FormFieldOption.fromJson(item));
      }
    }

    Map<String, dynamic>? validation;
    final rawValidation = json['validation'];
    if (rawValidation is Map<String, dynamic>) {
      validation = rawValidation;
    }

    return FormFieldSchema(
      key: (json['key'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      type: (json['type'] ?? 'TEXT').toString().toUpperCase(),
      required: json['required'] == true,
      validation: validation,
      options: options,
    );
  }
}

String _optionLabel(FormFieldSchema field, String value) {
  for (final option in field.options) {
    if (option.value == value) return option.label;
  }
  return value;
}

/// Formats a dynamic form value for read-only display (keeps type logic in one place).
String formatDynamicFieldValue(FormFieldSchema field, dynamic value) {
  if (value == null) return '-';

  switch (field.type) {
    case 'MULTI_SELECT':
      if (value is List) {
        if (value.isEmpty) return '-';
        return value.map((e) => _optionLabel(field, e.toString())).join(', ');
      }
      return value.toString().isEmpty ? '-' : value.toString();
    case 'RADIO':
      return _optionLabel(field, value.toString());
    default:
      final text = value.toString();
      return text.isEmpty ? '-' : text;
  }
}

// ================================
// NEW CODE END
// ================================
