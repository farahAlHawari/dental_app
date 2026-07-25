import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/features/register/presentation/widgets/birth_date_field.dart';
import 'package:dental_app/features/register/presentation/widgets/chronic_diseases_widget.dart';
import 'package:dental_app/features/register/presentation/widgets/gender_selector_widget.dart';

class PatientInfoForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final bool isCreateMode;
  final void Function(Map<String, dynamic> data) onSave;

  const PatientInfoForm({
    super.key,
    this.initialData,
    required this.isCreateMode,
    required this.onSave,
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
  final _allergiesController = TextEditingController();

  String _gender = "";
  List<String> selectedDiseases = [];

  final List<String> diseases = [
    "Diabetes",
    "Hypertension",
    "Asthma",
    "Heart Disease",
    "Thyroid",
    "Kidney Disease",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    if (data != null) {
      _nameController.text = data["name"] ?? "";
      _dobController.text = data["dob"] ?? "";
      _gender = data["gender"] ?? "";
      selectedDiseases = List<String>.from(data["diseases"] ?? []);
      _allergiesController.text = data["allergies"] ?? "";
      _imagePath = data["image"];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  void _toggleDisease(String disease) {
    setState(() {
      if (selectedDiseases.contains(disease)) {
        selectedDiseases.remove(disease);
      } else {
        selectedDiseases.add(disease);
      }
    });
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
    final updatedData = {
      "name": _nameController.text,
      "dob": _dobController.text,
      "gender": _gender,
      "diseases": selectedDiseases,
      "allergies": _allergiesController.text,
      "image": _image?.path ?? _imagePath,
    };
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
                  widget.isCreateMode ? "Medical Information" : "Edit Patient File",
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
                      ? "Please enter patient medical information"
                      : "Update patient medical information",
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
        Text("Patient Name", style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
        const SizedBox(height: 8),
        AppTextField(
          controller: _nameController,
          hint: "Ahmad Mohammad",
          prefixIcon: Icons.person,
        ),

        const SizedBox(height: 20),
        Text("BirthDate", style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
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
                _dobController.text = date.toIso8601String().split("T").first;
              });
            }
          },
        ),

        const SizedBox(height: 20),
        Text("Gender", style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
        const SizedBox(height: 10),
        GenderSelector(
          selectedGender: _gender,
          onChanged: (value) => setState(() => _gender = value),
        ),

        const SizedBox(height: 20),
        Text("Chronic Diseases", style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ChronicDiseasesWidget(
            diseases: diseases,
            selected: selectedDiseases,
            onChanged: _toggleDisease,
          ),
        ),

        const SizedBox(height: 20),
        Text("Allergies", style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
        const SizedBox(height: 8),
        AppTextField(
          controller: _allergiesController,
          hint: 'Do You Have any allergies?(example: Penicillin or any medicine)',
          prefixIcon: Icons.medical_information,
          maxLines: 3,
        ),

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
              widget.isCreateMode ? "Save My Information" : "Save Changes",
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