import 'dart:io';

import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/medical_archive_page.dart';
import 'package:dental_app/features/profile/presentation/pages/profile_page.dart';
import 'package:dental_app/features/register/presentation/widgets/birth_date_field.dart';
import 'package:dental_app/features/register/presentation/widgets/chronic_diseases_widget.dart';
import 'package:dental_app/features/register/presentation/widgets/gender_selector_widget.dart';
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
final _allergiesController = new TextEditingController();

  String _gender = "";

final List<String> diseases = [
  "Diabetes",
  "Hypertension",
  "Asthma",
  "Heart Disease",
  "Thyroid",
  "Kidney Disease",
  "Other",
];

List<String> selectedDiseases = [];

void _toggleDisease(String disease) {
  setState(() {
    if (selectedDiseases.contains(disease)) {
      selectedDiseases.remove(disease);
    } else {
      selectedDiseases.add(disease);
    }
  });
}


    @override
  void initState() {
    super.initState();
    _toothController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); 
  }
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
                          child: Column(
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
                                        child: Text("Medical Information",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontSize: 18,
                                          
                                        ),),
                                      ),
                                      SizedBox(height: 5,),
                                      Center(
                                        child: Text("Please enter patient medical information",
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

                                 Text("Patient Name",textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                
                              ),
                              ),
                              const SizedBox(height: 8),
                            AppTextField(
  controller: _nameController,
  hint: "Ahmad Mohaamad",
  prefixIcon: Icons.person,
),
                              
                              SizedBox(height: 20,),
                               Text("BirthDate",textAlign: TextAlign.left,
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
      _dobController.text = date.toIso8601String().split("T").first;
    }
  },
),

const SizedBox(height: 20),
Text("Gender",textAlign: TextAlign.left,
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
Text("Chronic Diseases",textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                
                              ),
                              ),
                               SizedBox(height: 10,),
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
)     ,
SizedBox(height: 20,)  ,
 Text("Allergies",textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                
                              ),
                              ),
                              const SizedBox(height: 8),
                            AppTextField(
  controller: _allergiesController,
  hint:  'Do You Have any allergies?(example: Penicillin or any medicine)',
  prefixIcon: Icons.medical_information,
   
                                maxLines: 3,
),
                              
                              SizedBox(height: 20,) ,
                                SizedBox(
  width: double.infinity,
  height: 54,
  child: ElevatedButton(
    onPressed: () {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettings(),));
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),));
    },
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
          "Save My information",
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