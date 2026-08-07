import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/profile/data/datasources/patient_remote_data_source.dart';
import 'package:dental_app/features/profile/domain/repositories/patient_repository_impl.dart';
import 'package:dental_app/features/profile/presentation/pages/patient_info_form.dart';
import 'package:dental_app/features/profile/presentation/pages/patient_info_view.dart';
import 'package:dental_app/features/register/presentation/widgets/form_field_schema.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dental_app/features/profile/presentation/pages/profile_page.dart';

class MedicalInfo extends StatefulWidget {
  final Map<String, dynamic>? patientData;
  // ================================
  // NEW CODE START
  // ================================
  final String? patientId;
  // ================================
  // NEW CODE END
  // ================================
  const MedicalInfo({
    super.key,
    this.patientData,
    // ================================
    // NEW CODE START
    // ================================
    this.patientId,
    // ================================
    // NEW CODE END
    // ================================
  });

  @override
  State<MedicalInfo> createState() => _MedicalInfoState();
}

class _MedicalInfoState extends State<MedicalInfo> {
  late bool _isEditing = widget.patientData == null &&
      (widget.patientId == null || widget.patientId!.isEmpty);

  // ================================
  // NEW CODE START
  // ================================
  final _repository = PatientRepositoryImpl(
    remoteDataSource: PatientRemoteDataSource(api: DioConsumer(dio: Dio())),
  );

  Map<String, dynamic>? _patientData;
  List<FormFieldSchema> _schema = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _patientData = widget.patientData;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    // TEMP preview delay — remove later if not needed.
    await ShimmerPreview.wait();
    if (!mounted) return;

    final schemaResult = await _repository.getFormSchema();
    if (!mounted) return;

    await schemaResult.fold(
      (failure) async {
        setState(() {
          _loading = false;
          _error = failure.errMessage;
        });
      },
      (schema) async {
        _schema = schema;
        final id = widget.patientId;
        if (id != null && id.isNotEmpty) {
          final detailResult = await _repository.getPatientById(id);
          if (!mounted) return;
          detailResult.fold(
            (failure) {
              setState(() {
                _loading = false;
                _error = failure.errMessage;
              });
            },
            (data) {
              setState(() {
                _patientData = data;
                _loading = false;
                _isEditing = false;
              });
            },
          );
        } else {
          setState(() => _loading = false);
        }
      },
    );
  }
  // ================================
  // NEW CODE END
  // ================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Edit Medical File".tr() : "Patient File".tr()),
      ),
      // ================================
      // MODIFIED
      // ================================
      body: _loading
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const PatientMedicalFormShimmer(dynamicFieldCount: 5),
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!),
                      TextButton(onPressed: _load, child: Text('Retry'.tr())),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _isEditing
                      ? PatientInfoForm(
                          initialData: _patientData,
                          isCreateMode: _patientData == null,
                          schema: _schema,
                          onSave: (data) {
                            if (_patientData == null &&
                                (widget.patientId == null ||
                                    widget.patientId!.isEmpty)) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ProfilePage()),
                              );
                            } else {
                              Navigator.pop(context, data);
                            }
                          },
                        )
                      : PatientInfoView(
                          name: (_patientData?["fullName"] ??
                                  _patientData?["name"] ??
                                  "")
                              .toString(),
                          dob: (_patientData?["birthDate"] ??
                                  _patientData?["dob"] ??
                                  "")
                              .toString(),
                          gender: (_patientData?["gender"] ?? "").toString(),
                          schema: _schema,
                          formValues: Map<String, dynamic>.from(
                            (_patientData?["formValues"] is Map)
                                ? _patientData!["formValues"] as Map
                                : {},
                          ),
                          avatarImage: null,
                          onEditPressed: () =>
                              setState(() => _isEditing = true),
                        ),
                ),
      // ================================
      // MODIFIED END
      // ================================
    );
  }
}
