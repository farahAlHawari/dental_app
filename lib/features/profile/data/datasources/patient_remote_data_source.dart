import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';
import 'package:dental_app/core/utils/api_date_utils.dart';
import 'package:dental_app/core/utils/patient_status_guard.dart';
import 'package:dental_app/features/register/presentation/widgets/form_field_schema.dart';

class PatientRemoteDataSource {
  final DioConsumer api;
  PatientRemoteDataSource({required this.api});

  /// Optional schema cache for DATE conversion when preparing formValues.
  List<FormFieldSchema>? _schemaCache;

  Future<List<FormFieldSchema>> getFormSchema() async {
    final response = await api.get(EndPoints.patientsFormSchema);
    final data = (response as Map<String, dynamic>)['data'];

    List<dynamic> rawList;
    if (data is List) {
      rawList = data;
    } else if (data is Map<String, dynamic>) {
      rawList =
          (data['fields'] ?? data['schema'] ?? data['items'] ?? []) as List;
    } else {
      rawList = const [];
    }

    final schema = rawList
        .whereType<Map>()
        .map((e) => FormFieldSchema.fromJson(Map<String, dynamic>.from(e)))
        .where((f) => f.key.isNotEmpty)
        .toList();
    _schemaCache = schema;
    return schema;
  }

  Map<String, dynamic> _normalizePatient(Map<String, dynamic> data) {
    final normalized = Map<String, dynamic>.from(data);
    if (normalized.containsKey('birthDate')) {
      normalized['birthDate'] =
          ApiDateUtils.toDisplayDate(normalized['birthDate']);
    }
    if (normalized.containsKey('gender')) {
      normalized['gender'] = ApiDateUtils.toUiGender(normalized['gender']);
    }
    if (normalized.containsKey('status')) {
      normalized['status'] =
          PatientStatusGuard.normalize(normalized['status']?.toString());
    } else {
      normalized['status'] = PatientStatusGuard.active;
    }

    final formValues = normalized['formValues'];
    final cleaned = <String, dynamic>{};
    final dateKeys = _dateFieldKeys();

    if (formValues is List) {
      for (final item in formValues) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        final key = (map['key'] ?? '').toString();
        if (key.isEmpty) continue;
        var value = map['value'];
        if (dateKeys.contains(key) || _looksLikeIsoDate(value)) {
          value = ApiDateUtils.toDisplayDate(value);
        }
        cleaned[key] = value;
      }
    } else if (formValues is Map) {
      formValues.forEach((key, value) {
        final k = key.toString();
        if (dateKeys.contains(k) || _looksLikeIsoDate(value)) {
          cleaned[k] = ApiDateUtils.toDisplayDate(value);
        } else {
          cleaned[k] = value;
        }
      });
    }

    normalized['formValues'] = cleaned;
    return normalized;
  }

  Set<String> _dateFieldKeys() {
    final schema = _schemaCache;
    if (schema == null) return {};
    return schema
        .where((f) => f.type.toUpperCase() == 'DATE')
        .map((f) => f.key)
        .toSet();
  }

  bool _looksLikeIsoDate(dynamic value) {
    if (value is! String) return false;
    return RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(value.trim());
  }

  /// Backend expects formValues: [ { "key": "...", "value": ... }, ... ]
  /// Optional empty fields are omitted (null / "" / []).
  List<Map<String, dynamic>> _prepareFormValues(
    Map<String, dynamic> formValues, {
    List<FormFieldSchema>? schema,
  }) {
    final prepared = <Map<String, dynamic>>[];
    final dateKeys = <String>{};
    if (schema != null) {
      for (final field in schema) {
        if (field.type.toUpperCase() == 'DATE') {
          dateKeys.add(field.key);
        }
      }
    } else {
      dateKeys.addAll(_dateFieldKeys());
    }

    formValues.forEach((key, value) {
      final trimmedKey = key.toString().trim();
      if (trimmedKey.isEmpty) return;
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      if (value is List && value.isEmpty) return;

      dynamic apiValue = value;
      if (dateKeys.contains(trimmedKey) && value is String) {
        apiValue = ApiDateUtils.toApiDate(value);
      }

      prepared.add({
        "key": trimmedKey,
        "value": apiValue,
      });
    });

    return prepared;
  }

  Map<String, dynamic> _extractData(dynamic response) {
    if (response is! Map) {
      throw FormatException('Unexpected patient response: $response');
    }
    final map = Map<String, dynamic>.from(response);
    final data = map['data'];
    if (data is Map) {
      return _normalizePatient(Map<String, dynamic>.from(data));
    }
    if (map.containsKey('id') ||
        map.containsKey('_id') ||
        map.containsKey('fullName')) {
      return _normalizePatient(map);
    }
    return map;
  }

  Future<Map<String, dynamic>> createPatient({
    required String fullName,
    required String birthDate,
    required String gender,
    required Map<String, dynamic> formValues,
    List<FormFieldSchema>? schema,
  }) async {
    final response = await api.post(EndPoints.patients, data: {
      "fullName": fullName,
      "birthDate": ApiDateUtils.toApiDate(birthDate),
      "gender": ApiDateUtils.toApiGender(gender),
      "formValues": _prepareFormValues(formValues, schema: schema),
    });
    return _extractData(response);
  }

  Future<List<Map<String, dynamic>>> getMyPatients() async {
    final response = await api.get(EndPoints.patientsMy);
    final data = (response as Map<String, dynamic>)['data'];

    List<Map<String, dynamic>> patients = [];
    if (data is List) {
      patients = data
          .whereType<Map>()
          .map((e) => _normalizePatient(Map<String, dynamic>.from(e)))
          .toList();
    } else if (data is Map<String, dynamic>) {
      final list = data['patients'] ?? data['items'] ?? data['data'];
      if (list is List) {
        patients = list
            .whereType<Map>()
            .map((e) => _normalizePatient(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    return patients;
  }

  Future<Map<String, dynamic>> getPatientById(String id) async {
    final response = await api.get(EndPoints.patientById(id));
    return _extractData(response);
  }

  Future<Map<String, dynamic>> updatePatient({
    required String id,
    required String fullName,
    required String birthDate,
    required String gender,
    required Map<String, dynamic> formValues,
    List<FormFieldSchema>? schema,
  }) async {
    final response = await api.patch(EndPoints.patientById(id), data: {
      "fullName": fullName,
      "birthDate": ApiDateUtils.toApiDate(birthDate),
      "gender": ApiDateUtils.toApiGender(gender),
      "formValues": _prepareFormValues(formValues, schema: schema),
    });
    return _extractData(response);
  }
}
