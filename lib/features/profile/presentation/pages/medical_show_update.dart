import 'dart:io';

import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/utils/api_date_utils.dart';
import 'package:dental_app/core/utils/patient_status_guard.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/core/navigation/post_auth_navigation.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/core/api/end_points.dart';
import 'package:dental_app/features/profile/data/datasources/patient_remote_data_source.dart';
import 'package:dental_app/features/profile/domain/repositories/patient_repository_impl.dart';
import 'package:dental_app/features/profile_image/data/datasources/upload_profile_image_remote_data_source.dart';
import 'package:dental_app/features/profile_image/domain/repositories/upload_profile_image_repository_impl.dart';
import 'package:dental_app/features/register/presentation/widgets/birth_date_field.dart';
import 'package:dental_app/features/register/presentation/widgets/dynamic_field_widget.dart';
import 'package:dental_app/features/register/presentation/widgets/field_validation_utils.dart';
import 'package:dental_app/features/register/presentation/widgets/form_field_schema.dart';
import 'package:dental_app/features/register/presentation/widgets/gender_selector_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class MedicalInfo extends StatefulWidget {
  /// إذا كانت null => وضع "إنشاء ملف جديد"
  /// إذا فيها بيانات => وضع "عرض" ثم إمكانية التعديل
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

class _MedicalInfoState extends State<MedicalInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController _toothController;
  File? _image;
  String? _imagePath; // للصورة الأصلية القادمة من البيانات
  final ImagePicker _picker = ImagePicker();

  final _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String _gender = "";

  // ================================
  // NEW CODE START
  // ================================
  final _repository = PatientRepositoryImpl(
    remoteDataSource: PatientRemoteDataSource(api: DioConsumer(dio: Dio())),
  );

  // ================================
  // NEW CODE START — profile_image feature
  // ================================
  final _uploadProfileImageRepository = UploadProfileImageRepositoryImpl(
    remoteDataSource: UploadProfileImageRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );
  // ================================
  // NEW CODE END
  // ================================

  String? _patientId;
  String _patientStatus = PatientStatusGuard.active;
  List<FormFieldSchema> _schema = [];
  final Map<String, dynamic> _formValues = {};
  bool _loading = true;
  bool _submitting = false;
  String? _loadError;
  // ================================
  // NEW CODE END
  // ================================

  // ================================
  // MODIFIED
  // ================================
  bool get _isCreateMode =>
      widget.patientData == null &&
      (widget.patientId == null || widget.patientId!.isEmpty) &&
      (_patientId == null || _patientId!.isEmpty);
  // ================================
  // MODIFIED END
  // ================================
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.patientData == null &&
        (widget.patientId == null || widget.patientId!.isEmpty);

    // ================================
    // MODIFIED
    // ================================
    _patientId = widget.patientId;
    final data = widget.patientData;
    if (data != null) {
      _nameController.text =
          (data["fullName"] ?? data["name"] ?? "").toString();
      _dobController.text =
          (data["birthDate"] ?? data["dob"] ?? "").toString();
      _gender = (data["gender"] ?? "").toString();
      _imagePath = data["image"]?.toString();
      final formValues = data["formValues"];
      if (formValues is Map) {
        formValues.forEach((key, value) {
          _formValues[key.toString()] = value;
        });
      }
    }
    // ================================
    // MODIFIED END
    // ================================

    _toothController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // ================================
    // NEW CODE START
    // ================================
    _loadInitialData();
    // ================================
    // NEW CODE END
    // ================================
  }

  // ================================
  // NEW CODE START
  // ================================
  Future<void> _loadInitialData() async {
    setState(() {
      _loading = true;
      _loadError = null;
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
          _loadError = failure.errMessage;
        });
      },
      (schema) async {
        _schema = schema;
        for (final field in schema) {
          if (!_formValues.containsKey(field.key)) {
            _formValues[field.key] =
                field.type == 'MULTI_SELECT' ? <String>[] : null;
          }
        }

        final id = widget.patientId;
        if (id != null && id.isNotEmpty) {
          final detailResult = await _repository.getPatientById(id);
          if (!mounted) return;
          detailResult.fold(
            (failure) {
              setState(() {
                _loading = false;
                _loadError = failure.errMessage;
              });
            },
            (data) {
              _applyPatientData(data);
              setState(() {
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

  void _applyPatientData(Map<String, dynamic> data) {
    _patientId = (data['id'] ?? data['_id'] ?? _patientId)?.toString();
    _nameController.text =
        (data['fullName'] ?? data['name'] ?? '').toString();
    _dobController.text =
        (data['birthDate'] ?? data['dob'] ?? '').toString();
    _gender = (data['gender'] ?? '').toString();
    _patientStatus =
        PatientStatusGuard.normalize(data['status']?.toString());
    // ================================
    // NEW CODE START — profileImage from API
    // ================================
    final profileUrl = _extractProfileImageUrl(data);
    if (profileUrl != null && profileUrl.isNotEmpty) {
      _imagePath = profileUrl;
    } else if (data['image'] != null) {
      _imagePath = data['image']?.toString();
    }
    // ================================
    // NEW CODE END
    // ================================
    final formValues = data['formValues'];
    if (formValues is Map) {
      formValues.forEach((key, value) {
        _formValues[key.toString()] = value;
      });
    }
  }

  // ================================
  // NEW CODE START
  // ================================
  String? _extractProfileImageUrl(Map<String, dynamic> data) {
    final profileImage = data['profileImage'];
    if (profileImage is Map) {
      final url = profileImage['url']?.toString();
      if (url != null && url.trim().isNotEmpty) return url.trim();
    }
    return null;
  }

  String _resolveImageUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final base = EndPoints.baserUrl;
    // baserUrl ends with /api/v1/ — uploads are typically host-rooted.
    final origin = base.replaceFirst(RegExp(r'/api/v1/?$'), '');
    if (url.startsWith('/')) return '$origin$url';
    return '$origin/$url';
  }

  /// Uploads selected local image via profile_image feature. Never throws.
  /// Returns false only when upload was attempted and failed.
  Future<bool> _uploadSelectedImageIfNeeded(String patientId) async {
    if (_image == null) return true;

    final uploadResult =
        await _uploadProfileImageRepository.uploadProfileImage(
      patientId: patientId,
      imagePath: _image!.path,
    );
    if (!mounted) return true;

    return uploadResult.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.errMessage)),
        );
        return false;
      },
      (data) {
        _applyPatientData(data);
        _image = null;
        return true;
      },
    );
  }
  // ================================
  // NEW CODE END
  // ================================

  bool _validateForm() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Full Name is required'.tr())),
      );
      return false;
    }
    if (_dobController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Birth Date is required'.tr())),
      );
      return false;
    }
    if (_gender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gender is required'.tr())),
      );
      return false;
    }

    for (final field in _schema) {
      final error =
          FieldValidationUtils.validateField(field, _formValues[field.key]);
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
        return false;
      }
    }
    return true;
  }

  void _toggleEditing() {
    if (!_isEditing) {
      if (!PatientStatusGuard.ensureEditable(context, _patientStatus)) {
        return;
      }
    }
    setState(() => _isEditing = !_isEditing);
  }
  // ================================
  // NEW CODE END
  // ================================

  Future<void> _pickImage() async {
    if (!_isCreateMode &&
        !PatientStatusGuard.ensureEditable(context, _patientStatus)) {
      return;
    }
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  @override
  void dispose() {
    _toothController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // ================================
  // MODIFIED
  // ================================
  Future<void> _handleSave() async {
    if (_submitting) return;
    if (!_isCreateMode &&
        !PatientStatusGuard.ensureEditable(context, _patientStatus)) {
      return;
    }
    if (!_validateForm()) return;

    setState(() => _submitting = true);

    final fullName = _nameController.text.trim();
    final birthDate = _dobController.text.trim();
    final formValues = Map<String, dynamic>.from(_formValues);

    if (_isCreateMode || _patientId == null || _patientId!.isEmpty) {
      final result = await _repository.createPatient(
        fullName: fullName,
        birthDate: birthDate,
        gender: _gender,
        formValues: formValues,
        schema: _schema,
      );
      if (!mounted) return;
      await result.fold(
        (failure) async {
          setState(() => _submitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.errMessage)),
          );
        },
        (data) async {
          final id = (data['id'] ?? data['_id'])?.toString();
          final status =
              PatientStatusGuard.normalize(data['status']?.toString());
          if (id != null && id.isNotEmpty) {
            await SharedPrefs.saveSelectedPatientId(id);
            await SharedPrefs.saveSelectedPatientStatus(status);
            _patientId = id;
            _patientStatus = status;
            // Create succeeded — upload image if selected (do not lose patient).
            await _uploadSelectedImageIfNeeded(id);
          }
          if (!mounted) return;
          setState(() => _submitting = false);
          // Feature 6: sole post-auth router (not direct MainNavigationPage).
          await PostAuthNavigation.go(context);
        },
      );
      return;
    }

    final result = await _repository.updatePatient(
      id: _patientId!,
      fullName: fullName,
      birthDate: birthDate,
      gender: _gender,
      formValues: formValues,
      schema: _schema,
    );
    if (!mounted) return;
    await result.fold(
      (failure) async {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.errMessage)),
        );
      },
      (data) async {
        _applyPatientData(data);
        // Upload only when user picked a new local image.
        await _uploadSelectedImageIfNeeded(_patientId!);
        if (!mounted) return;
        setState(() {
          _submitting = false;
          _isEditing = false;
        });
        Navigator.pop(context, data);
      },
    );
  }
  // ================================
  // MODIFIED END
  // ================================

  ImageProvider? get _avatarImage {
    if (_image != null) return FileImage(_image!);
    if (_imagePath == null || _imagePath!.isEmpty) return null;
    if (_imagePath!.startsWith('assets/')) {
      return AssetImage(_imagePath!);
    }
    if (_imagePath!.startsWith('http://') ||
        _imagePath!.startsWith('https://') ||
        _imagePath!.startsWith('/')) {
      return NetworkImage(_resolveImageUrl(_imagePath!));
    }
    return FileImage(File(_imagePath!));
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primary),
        title: Text(
          _isCreateMode
              ? "New Medical File".tr()
              : (_isEditing ? "Edit Medical File".tr() : "Patient File".tr()),
          style: TextStyle(color: primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (!_isCreateMode)
            IconButton(
              icon: Icon(
                _isEditing ? Icons.close : Icons.edit_outlined,
                color: primary,
              ),
              onPressed: _toggleEditing,
            ),
        ],
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/background1.png',
                color: Theme.of(context).colorScheme.primary,
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // ================================
                  // NEW CODE START
                  // ================================
                  if (_loading) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
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
                        child: const PatientMedicalFormShimmer(
                          dynamicFieldCount: 5,
                        ),
                      ),
                    );
                  }
                  if (_loadError != null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_loadError!),
                          TextButton(
                            onPressed: _loadInitialData,
                            child: Text('Retry'.tr()),
                          ),
                        ],
                      ),
                    );
                  }
                  // ================================
                  // NEW CODE END
                  // ================================
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Theme.of(context).colorScheme.shadow,
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: _isEditing
                                ? _buildEditForm(context)
                                : _buildViewMode(context),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // وضع العرض (Patient File View)
  // ============================================================
  Widget _buildViewMode(BuildContext context) {
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
                backgroundImage: _avatarImage,
                child: _avatarImage == null
                    ? Icon(Icons.person, size: 50, color: primary)
                    : null,
              ),
              const SizedBox(height: 14),
              Text(
                _nameController.text.isEmpty
                    ? "Unnamed Patient".tr()
                    : _nameController.text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _gender.toLowerCase() == "male"
                          ? Icons.male
                          : Icons.female,
                      size: 16,
                      color: primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _gender.isEmpty ? "-" : _gender.tr(),
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
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
          value: _dobController.text.isEmpty ? "-" : _dobController.text,
        ),

        const SizedBox(height: 18),
        ..._schema.map(
          (field) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _infoRow(
              context,
              icon: Icons.medical_information_outlined,
              label: field.label,
              value: formatDynamicFieldValue(field, _formValues[field.key]),
            ),
          ),
        ),

        const SizedBox(height: 26),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: () {
              if (!PatientStatusGuard.ensureEditable(context, _patientStatus)) {
                return;
              }
              setState(() => _isEditing = true);
            },
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
                style: TextStyle(
                  fontSize: 14,
                  color: onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // وضع التعديل / الإنشاء (نفس الفورم الأصلي تبعك)
  // ============================================================
  Widget _buildEditForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Lottie.asset(
              'assets/animations/2.json',
              repeat: true,
              animate: true,
              width: 80,
              height: 70,
            ),
            const SizedBox(width: 5, height: 20),
            Column(
              children: [
                Text(
                  _isCreateMode ? "Medical Information".tr() : "Edit Patient File".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _isCreateMode
                      ? "Please enter patient medical information".tr()
                      : "Update patient medical information".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        GestureDetector(
          onTap: _pickImage,
          child: Center(
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 225, 236, 240),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: _avatarImage == null
                      ? Icon(Icons.person, size: 60, color: AppColors.primary)
                      : ClipOval(
                          child: Image(
                            image: _avatarImage!,
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 5,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: const Icon(
                      Icons.add_a_photo,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Text(
          "Patient Name".tr(),
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _nameController,
          hint: "Ahmad Mohammad".tr(),
          prefixIcon: Icons.person,
        ),

        const SizedBox(height: 20),
        Text(
          "Birth Date".tr(),
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
        ),
        const SizedBox(height: 10),
        BirthDateField(
          controller: _dobController,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() {
                // ================================
                // MODIFIED
                // ================================
                _dobController.text = ApiDateUtils.fromPicker(date);
                // ================================
                // MODIFIED END
                // ================================
              });
            }
          },
        ),

        const SizedBox(height: 20),
        Text(
          "Gender".tr(),
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
        ),
        const SizedBox(height: 10),
        GenderSelector(
          selectedGender: _gender,
          onChanged: (value) => setState(() => _gender = value),
        ),

        // ================================
        // MODIFIED
        // ================================
        const SizedBox(height: 20),
        ..._schema.map(
          (field) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: DynamicFieldWidget(
              field: field,
              value: _formValues[field.key],
              onChanged: (value) {
                setState(() {
                  _formValues[field.key] = value;
                });
              },
            ),
          ),
        ),
        // ================================
        // MODIFIED END
        // ================================

        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _submitting ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _submitting
                      ? "Saving...".tr()
                      : (_isCreateMode
                          ? "Save My Information".tr()
                          : "Save Changes".tr()),
                  style: TextStyle(
                    color: AppColors.background,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
