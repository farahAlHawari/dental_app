import 'package:dental_app/core/utils/patient_profile_image.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/patient_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SwitchAccountBottomSheet extends StatelessWidget {
  // ================================
  // NEW CODE START
  // ================================
  final List<Map<String, dynamic>> patients;
  final String? selectedPatientId;
  final ValueChanged<Map<String, dynamic>>? onPatientSelected;
  // ================================
  // NEW CODE END
  // ================================

  const SwitchAccountBottomSheet({
    super.key,
    // ================================
    // NEW CODE START
    // ================================
    this.patients = const [],
    this.selectedPatientId,
    this.onPatientSelected,
    // ================================
    // NEW CODE END
    // ================================
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),

             Text(
              "Switch Account".tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ================================
            // MODIFIED
            // ================================
            if (patients.isEmpty)
               Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text("No patients found".tr()),
              )
            else
              ...patients.map((patient) {
                final id = (patient['id'] ?? patient['_id'] ?? '').toString();
                final name =
                    (patient['fullName'] ?? patient['name'] ?? '').toString();
                final gender = (patient['gender'] ?? '').toString();
                return _accountTile(
                  context,
                  id: id,
                  name: name.isEmpty ? 'Unnamed Patient'.tr() : name,
                  gender: gender.isEmpty ? '-' : gender,
                  imageUrl: PatientProfileImage.urlOf(patient),
                  selected: id == selectedPatientId,
                  patient: patient,
                );
              }),
            // ================================
            // MODIFIED END
            // ================================

            const SizedBox(height: 12),

            

          ],
        ),
      ),
    );
  }

  Widget _accountTile(
    BuildContext context, {
    // ================================
    // MODIFIED
    // ================================
    required String id,
    required String name,
    required String gender,
    required String? imageUrl,
    required bool selected,
    required Map<String, dynamic> patient,
    // ================================
    // MODIFIED END
    // ================================
  }) {
    return ListTile(
      leading: PatientAvatar(
        imageUrl: imageUrl,
        radius: 22,
      ),
      title: Text(name),
      // ================================
      // MODIFIED
      // ================================
      subtitle: Text(gender),
      trailing: Icon(
        selected ? Icons.check_circle : Icons.arrow_forward_ios_rounded,
        size: 16,
        color: selected ? Theme.of(context).colorScheme.primary : null,
      ),
      onTap: () async {
  if (id.isNotEmpty) {
    await SharedPrefs.saveSelectedPatientId(id);
  }

  onPatientSelected?.call(patient);

  if (context.mounted) {
    Navigator.pop(context, true);
  }
},
      // ================================
      // MODIFIED END
      // ================================
    );
  }
}
