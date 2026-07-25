import 'dart:io';

import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/features/profile/presentation/pages/profile_page.dart';
import 'package:dental_app/features/register/presentation/widgets/birth_date_field.dart';
import 'package:dental_app/features/register/presentation/widgets/chronic_diseases_widget.dart';
import 'package:dental_app/features/register/presentation/widgets/gender_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class MedicalInfo extends StatefulWidget {
  /// إذا كانت null => وضع "إنشاء ملف جديد"
  /// إذا فيها بيانات => وضع "عرض" ثم إمكانية التعديل
  final Map<String, dynamic>? patientData;

  const MedicalInfo({super.key, this.patientData});

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

  bool get _isCreateMode => widget.patientData == null;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = _isCreateMode;

    final data = widget.patientData;
    if (data != null) {
      _nameController.text = data["name"] ?? "";
      _dobController.text = data["dob"] ?? "";
      _gender = data["gender"] ?? "";
      selectedDiseases = List<String>.from(data["diseases"] ?? []);
      _allergiesController.text = data["allergies"] ?? "";
      _imagePath = data["image"];
    }

    _toothController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
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

  @override
  void dispose() {
    _toothController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final updatedData = {
      "name": _nameController.text,
      "dob": _dobController.text,
      "gender": _gender,
      "diseases": selectedDiseases,
      "allergies": _allergiesController.text,
      "image": _image?.path ?? _imagePath,
    };

    if (_isCreateMode) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else {
      // رجّع البيانات المعدّلة للصفحة السابقة (FamilyAccount)
      setState(() {
        _imagePath = updatedData["image"] as String?;
        _isEditing = false;
      });
      Navigator.pop(context, updatedData);
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
              ? "New Medical File"
              : (_isEditing ? "Edit Medical File" : "Patient File"),
          style: TextStyle(color: primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (!_isCreateMode)
            IconButton(
              icon: Icon(
                _isEditing ? Icons.close : Icons.edit_outlined,
                color: primary,
              ),
              onPressed: () => setState(() => _isEditing = !_isEditing),
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
                    ? "Unnamed Patient"
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
                      _gender.isEmpty ? "-" : _gender,
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
          label: "Birth Date",
          value: _dobController.text.isEmpty ? "-" : _dobController.text,
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            Icon(Icons.medical_services_outlined, size: 18, color: primary),
            const SizedBox(width: 8),
            Text(
              "Chronic Diseases",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        selectedDiseases.isEmpty
            ? Text(
                "No chronic diseases reported",
                style: TextStyle(
                  fontSize: 13,
                  color: onSurface.withOpacity(0.5),
                ),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedDiseases
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

        const SizedBox(height: 20),

        _infoRow(
          context,
          icon: Icons.medical_information_outlined,
          label: "Allergies",
          value: _allergiesController.text.isEmpty
              ? "No known allergies"
              : _allergiesController.text,
        ),

        const SizedBox(height: 26),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _isEditing = true),
            icon: Icon(Icons.edit_outlined, color: primary),
            label: Text(
              "Edit Information",
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
                  _isCreateMode ? "Medical Information" : "Edit Patient File",
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
                      ? "Please enter patient medical information"
                      : "Update patient medical information",
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
          "Patient Name",
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _nameController,
          hint: "Ahmad Mohammad",
          prefixIcon: Icons.person,
        ),

        const SizedBox(height: 20),
        Text(
          "BirthDate",
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
                _dobController.text = date.toIso8601String().split("T").first;
              });
            }
          },
        ),

        const SizedBox(height: 20),
        Text(
          "Gender",
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
        ),
        const SizedBox(height: 10),
        GenderSelector(
          selectedGender: _gender,
          onChanged: (value) => setState(() => _gender = value),
        ),

        const SizedBox(height: 20),
        Text(
          "Chronic Diseases",
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
        ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChronicDiseasesWidget(
                diseases: diseases,
                selected: selectedDiseases,
                onChanged: _toggleDisease,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        Text(
          "Allergies",
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
        ),
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
            onPressed: _handleSave,
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
                  _isCreateMode ? "Save My Information" : "Save Changes",
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