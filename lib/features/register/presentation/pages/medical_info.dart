import 'dart:io';

import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/navigation/post_auth_navigation.dart';
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/utils/api_date_utils.dart';
import 'package:dental_app/core/utils/patient_status_guard.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
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
  const MedicalInfo({super.key});

  @override
  State<MedicalInfo> createState() => _MedicalInfoState();
}

class _MedicalInfoState extends State<MedicalInfo>
    with SingleTickerProviderStateMixin {

int _selectedIndex = -1;
    late AnimationController _toothController;
    File? _image;
final ImagePicker _picker = ImagePicker();
final _nameController = new TextEditingController();
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

  List<FormFieldSchema> _schema = [];
  final Map<String, dynamic> _formValues = {};
  bool _schemaLoading = true;
  bool _submitting = false;
  String? _schemaError;
  // ================================
  // NEW CODE END
  // ================================

    @override
  void initState() {
    super.initState();
    _toothController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    // ================================
    // NEW CODE START
    // ================================
    _loadSchema();
    // ================================
    // NEW CODE END
    // ================================
  }

  // ================================
  // NEW CODE START
  // ================================
  Future<void> _loadSchema() async {
    setState(() {
      _schemaLoading = true;
      _schemaError = null;
    });

    // TEMP preview delay — remove later if not needed.
    await ShimmerPreview.wait();
    if (!mounted) return;

    final result = await _repository.getFormSchema();
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _schemaLoading = false;
          _schemaError = failure.errMessage;
        });
      },
      (schema) {
        setState(() {
          _schema = schema;
          for (final field in schema) {
            if (!_formValues.containsKey(field.key)) {
              _formValues[field.key] =
                  field.type == 'MULTI_SELECT' ? <String>[] : null;
            }
          }
          _schemaLoading = false;
        });
      },
    );
  }

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

  Future<void> _submitPatient() async {
    if (_submitting) return;
    if (!_validateForm()) return;

    setState(() => _submitting = true);

    final result = await _repository.createPatient(
      fullName: _nameController.text.trim(),
      birthDate: _dobController.text.trim(),
      gender: _gender,
      formValues: Map<String, dynamic>.from(_formValues),
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

          // ================================
          // NEW CODE START — upload after create (independent feature)
          // ================================
          if (_image != null) {
            final uploadResult =
                await _uploadProfileImageRepository.uploadProfileImage(
              patientId: id,
              imagePath: _image!.path,
            );
            if (!mounted) return;
            uploadResult.fold(
              (failure) {
                // Patient already created — show upload error, continue flow.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(failure.errMessage)),
                );
              },
              (_) {},
            );
          }
          // ================================
          // NEW CODE END
          // ================================
        }
        await SharedPrefs.savePatientOnboardingStep(
          SharedPrefs.onboardingComplete,
        );
        if (!mounted) return;
        setState(() => _submitting = false);
        await PostAuthNavigation.go(context);
      },
    );
  }
  // ================================
  // NEW CODE END
  // ================================
Future<void> _pickImage() async {
  final picked = await _picker.pickImage(source: ImageSource.gallery);

  if (picked != null) {
    setState(() {
      _image = File(picked.path);
    });
  }
}
  @override
  void dispose() {
 
    _toothController.dispose(); // لازم تعمليها dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: SizedBox.expand(
        child: Stack(        
          children: [
            Positioned.fill(
              child: Image.asset('assets/backgrounds/background1.png',color:Theme.of(context).colorScheme.primary , 
               fit: BoxFit.cover,),
            ),
            SafeArea(
              child:LayoutBuilder(
    builder: (context, constraints){
      return SingleChildScrollView(
                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child:  ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight, 
          ),
                    child: Column(
                     mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        Container(
                          width: double.infinity,
                          
                          padding: EdgeInsets.all(20),
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
                          child: _schemaLoading
                              ? const PatientMedicalFormShimmer(
                                  dynamicFieldCount: 5,
                                  includeHeader: true,
                                )
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  
                                  width: 60,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),

                              Row(
                                
                                children: [
                                  SizedBox(width: 0,),
Lottie.asset(
          'assets/animations/2.json',
          repeat: true,
          animate: true,
          width: 80,height: 70,
          
        ),
// Image.asset("assets/images/6.png",width: 40,),
SizedBox(width: 5,height: 20,),
                                  Column(
                                    children: [
                                      Center(
                                        child: Text("Medical Information".tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontSize: 18,
                                          
                                        ),),
                                      ),
                                      SizedBox(height: 5,),
                                      Center(
                                        child: Text("Please enter patient medical information".tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                          fontSize: 10,
                                          
                                        ),),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 20,),

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
            border: Border.all(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          child: _image == null
              ? Icon(
                  Icons.person,
                  size: 60,
                  color: AppColors.primary,
                )
              : ClipOval(
                  child: Image.file(
                    _image!,
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

                                 Text("Patient Name".tr(),textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                
                              ),
                              ),
                              const SizedBox(height: 8),
                            AppTextField(
  controller: _nameController,
  hint: "Ahmad Mohammad".tr(),
  prefixIcon: Icons.person,
),
                              
                              SizedBox(height: 20,),
                               Text("Birth Date".tr(),textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                
                              ),
                              ),
                               SizedBox(height: 10,),
                          BirthDateField(
  controller: _dobController,
  onTap: () async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      // ================================
      // MODIFIED
      // ================================
      _dobController.text = ApiDateUtils.fromPicker(date);
      // ================================
      // MODIFIED END
      // ================================
    }
  },
),

const SizedBox(height: 20),
Text("Gender".tr(),textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                
                              ),
                              ),
                               SizedBox(height: 10,),

GenderSelector(
  selectedGender: _gender,
  onChanged: (value) {
    setState(() {
      _gender = value;
    });
  },
),
SizedBox(height: 20,),
                              if (_schemaError != null)
                                Column(
                                  children: [
                                    Text(
                                      _schemaError!,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _loadSchema,
                                      child: Text('Retry'.tr()),
                                    ),
                                  ],
                                )
                              else
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
                              SizedBox(height: 20,) ,
                                SizedBox(
  width: double.infinity,
  height: 54,
  child: ElevatedButton(
    onPressed: _submitting || _schemaLoading ? null : _submitPatient,
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
          _submitting ? "Saving...".tr() : "Save My Information".tr(),
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
                          ),
                        )
                      ],
                    ),
                  ),
                );
    }
    
              ),
            )
          ],
        
        ),
      ),
    );
  }
}