import 'package:dental_app/core/utils/api_date_utils.dart';
import 'package:dental_app/features/register/presentation/widgets/form_field_schema.dart';
import 'package:easy_localization/easy_localization.dart';

/// Client-side FieldValidation rules from the backend schema contract.
///
/// Applies only the keys documented for each field type.
class FieldValidationUtils {
  static const supportedTypes = {
    'TEXT',
    'NUMBER',
    'DATE',
    'RADIO',
    'MULTI_SELECT',
    'TEXTAREA',
  };

  /// Returns an error message, or null if valid.
  /// Skips empty values for optional fields (caller should check [required] first).
  static String? validateField(FormFieldSchema field, dynamic value) {
    final empty = value == null ||
        (value is String && value.trim().isEmpty) ||
        (value is List && value.isEmpty);

    if (empty) {
      if (field.required) {
        return '{label} is required'.tr(namedArgs: {'label': field.label});
      }
      return null;
    }

    final type = field.type.toUpperCase();
    final validation = field.validation ?? const <String, dynamic>{};

    switch (type) {
      case 'TEXT':
      case 'TEXTAREA':
        return _validateText(field.label, value.toString(), validation);
      case 'NUMBER':
        return _validateNumber(field.label, value, validation);
      case 'DATE':
        return _validateDate(field.label, value.toString(), validation);
      case 'MULTI_SELECT':
        return _validateMultiSelect(field.label, value, validation);
      case 'RADIO':
        return _validateRadio(field, value);
      default:
        return null;
    }
  }

  static String? _validateText(
    String label,
    String text,
    Map<String, dynamic> validation,
  ) {
    final minLength = _asInt(validation['minLength']);
    final maxLength = _asInt(validation['maxLength']);
    final pattern = validation['pattern']?.toString();

    if (minLength != null && text.length < minLength) {
      return '{label} must be at least {n} characters'.tr(
        namedArgs: {'label': label, 'n': '$minLength'},
      );
    }
    if (maxLength != null && text.length > maxLength) {
      return '{label} must be at most {n} characters'.tr(
        namedArgs: {'label': label, 'n': '$maxLength'},
      );
    }
    if (pattern != null && pattern.isNotEmpty) {
      try {
        if (!RegExp(pattern).hasMatch(text)) {
          return '{label} format is invalid'.tr(namedArgs: {'label': label});
        }
      } catch (_) {
        // Invalid regex from schema — skip client pattern check.
      }
    }
    return null;
  }

  static String? _validateNumber(
    String label,
    dynamic value,
    Map<String, dynamic> validation,
  ) {
    final number = value is num ? value : num.tryParse(value.toString());
    if (number == null) {
      return '{label} must be a number'.tr(namedArgs: {'label': label});
    }

    final min = _asNum(validation['min']);
    final max = _asNum(validation['max']);
    final integer = validation['integer'] == true;

    if (integer && number % 1 != 0) {
      return '{label} must be an integer'.tr(namedArgs: {'label': label});
    }
    if (min != null && number < min) {
      return '{label} must be at least {min}'.tr(
        namedArgs: {'label': label, 'min': '$min'},
      );
    }
    if (max != null && number > max) {
      return '{label} must be at most {max}'.tr(
        namedArgs: {'label': label, 'max': '$max'},
      );
    }
    return null;
  }

  static String? _validateDate(
    String label,
    String raw,
    Map<String, dynamic> validation,
  ) {
    final date = ApiDateUtils.toApiDate(raw);
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date)) {
      return '{label} must be a valid date (YYYY-MM-DD)'
          .tr(namedArgs: {'label': label});
    }

    final min = validation['min']?.toString();
    final max = validation['max']?.toString();
    if (min != null && min.isNotEmpty) {
      final minDate = ApiDateUtils.toApiDate(min);
      if (date.compareTo(minDate) < 0) {
        return '{label} must be on or after {date}'.tr(
          namedArgs: {'label': label, 'date': minDate},
        );
      }
    }
    if (max != null && max.isNotEmpty) {
      final maxDate = ApiDateUtils.toApiDate(max);
      if (date.compareTo(maxDate) > 0) {
        return '{label} must be on or before {date}'.tr(
          namedArgs: {'label': label, 'date': maxDate},
        );
      }
    }
    return null;
  }

  static String? _validateMultiSelect(
    String label,
    dynamic value,
    Map<String, dynamic> validation,
  ) {
    if (value is! List) {
      return '{label} format is invalid'.tr(namedArgs: {'label': label});
    }
    final count = value.length;
    final minItems = _asInt(validation['minItems']);
    final maxItems = _asInt(validation['maxItems']);

    if (minItems != null && count < minItems) {
      return '{label} must have at least {n} item(s)'.tr(
        namedArgs: {'label': label, 'n': '$minItems'},
      );
    }
    if (maxItems != null && count > maxItems) {
      return '{label} must have at most {n} item(s)'.tr(
        namedArgs: {'label': label, 'n': '$maxItems'},
      );
    }
    return null;
  }

  static String? _validateRadio(FormFieldSchema field, dynamic value) {
    final selected = value.toString();
    final allowed = field.options.map((o) => o.value).toSet();
    if (allowed.isEmpty) return null;
    if (!allowed.contains(selected)) {
      return '{label} has an invalid option'
          .tr(namedArgs: {'label': field.label});
    }
    return null;
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static num? _asNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '');
  }
}
