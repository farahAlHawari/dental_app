import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/utils/api_date_utils.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/features/register/presentation/widgets/birth_date_field.dart';
import 'package:dental_app/features/register/presentation/widgets/dynamic_field_widget.dart';
import 'package:dental_app/features/register/presentation/widgets/form_field_schema.dart';
import 'package:dental_app/features/register/presentation/widgets/gender_selector_widget.dart';

class PatientInfoForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final bool isCreateMode;
  final void Function(Map<String, dynamic> data) onSave;

  // ================================
  // NEW CODE START
  // ================================
  final List<FormFieldSchema> schema;
  // ================================
  // NEW CODE END
  // ================================

  const PatientInfoForm({
    super.key,
    this.initialData,
    required this.isCreateMode,
    required this.onSave,
    // ================================
    // NEW CODE START
    // ================================
    this.schema = const [],
    // ================================
    // NEW CODE END
    // ================================
  });

  @override
  State<PatientInfoForm> createState() => _PatientInfoFormState();
}

class _PatientInfoFormState extends State<PatientInfoForm> {
  File? _image;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _dobController = TextEditingController();

  String _gender = "";

  // ================================
  // NEW CODE START
  // ================================
  final Map<String, dynamic> _formValues = {};
  // ================================
  // NEW CODE END
  // ================================

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    if (data != null) {
      // ================================
      // MODIFIED
      // ================================
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
      // ================================
      // MODIFIED END
      // ================================
    }

    // ================================
    // NEW CODE START
    // ================================
    for (final field in widget.schema) {
      if (!_formValues.containsKey(field.key)) {
        _formValues[field.key] =
            field.type == 'MULTI_SELECT' ? <String>[] : null;
      }
    }
    // ================================
    // NEW CODE END
    // ================================
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  ImageProvider? get _avatarImage {
    if (_image != null) return FileImage(_image!);
    if (_imagePath != null && _imagePath!.startsWith('assets/')) {
      return AssetImage(_imagePath!);
    }
    if (_imagePath != null) return FileImage(File(_imagePath!));
    return null;
  }

  void _handleSubmit() {
    // ================================
    // MODIFIED
    // ================================
    final updatedData = {
      "fullName": _nameController.text,
      "birthDate": _dobController.text,
      "gender": _gender,
      "formValues": Map<String, dynamic>.from(_formValues),
      "name": _nameController.text,
      "dob": _dobController.text,
      "image": _image?.path ?? _imagePath,
    };
    // ================================
    // MODIFIED END
    // ================================
    widget.onSave(updatedData);
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.isCreateMode ? "Medical Information".tr() : "Edit Patient File".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.isCreateMode
                      ? "Please enter patient medical information".tr()
                      : "Update patient medical information".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                    child: const Icon(Icons.add_a_photo, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
        Text("Patient Name".tr(), style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
        const SizedBox(height: 8),
        AppTextField(
          controller: _nameController,
          hint: "Ahmad Mohammad".tr(),
          prefixIcon: Icons.person,
        ),

        const SizedBox(height: 20),
        Text("Birth Date".tr(), style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
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
        Text("Gender".tr(), style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
        const SizedBox(height: 10),
        GenderSelector(
          selectedGender: _gender,
          onChanged: (value) => setState(() => _gender = value),
        ),

        // ================================
        // MODIFIED
        // ================================
        const SizedBox(height: 20),
        ...widget.schema.map(
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
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Text(
              widget.isCreateMode ? "Save My Information".tr() : "Save Changes".tr(),
              style: TextStyle(
                color: AppColors.background,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
