import 'package:dental_app/features/profile/presentation/pages/patient_info_form.dart';
import 'package:dental_app/features/profile/presentation/pages/patient_info_view.dart';
import 'package:flutter/material.dart';
import 'package:dental_app/features/profile/presentation/pages/profile_page.dart';

class MedicalInfo extends StatefulWidget {
  final Map<String, dynamic>? patientData;
  const MedicalInfo({super.key, this.patientData});

  @override
  State<MedicalInfo> createState() => _MedicalInfoState();
}

class _MedicalInfoState extends State<MedicalInfo> {
  late bool _isEditing = widget.patientData == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Edit Medical File" : "Patient File"),
      ),
      body: _isEditing
          ? PatientInfoForm(
              initialData: widget.patientData,
              isCreateMode: widget.patientData == null,
              onSave: (data) {
                if (widget.patientData == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => ProfilePage()),
                  );
                } else {
                  Navigator.pop(context, data);
                }
              },
            )
          : PatientInfoView(
              name: widget.patientData!["name"] ?? "",
              dob: widget.patientData!["dob"] ?? "",
              gender: widget.patientData!["gender"] ?? "",
              diseases: List<String>.from(widget.patientData!["diseases"] ?? []),
              allergies: widget.patientData!["allergies"] ?? "",
              avatarImage: null,
              onEditPressed: () => setState(() => _isEditing = true),
            ),
    );
  }
}