import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/widgets/patient_avatar.dart';
import 'package:dental_app/features/profile/presentation/widgets/switch_account.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String gender;
  /// Absolute or relative profile image URL from API (optional).
  final String? imageUrl;

  final VoidCallback? onEdit;
  final VoidCallback? onSwitchAccount;

  // ================================
  // NEW CODE START
  // ================================
  final List<Map<String, dynamic>> patients;
  final String? selectedPatientId;
  final ValueChanged<Map<String, dynamic>>? onPatientSelected;
  // ================================
  // NEW CODE END
  // ================================

  const ProfileCard({
    super.key,
    required this.name,
    required this.gender,
    this.imageUrl,
    this.onEdit,
    this.onSwitchAccount,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// الصورة من الـ API أو أيقونة افتراضية
          PatientAvatar(
            imageUrl: imageUrl,
            radius: 34,
          ),

          const SizedBox(width: 16),

          /// الاسم ورقم الملف
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(Icons.male,size: 20,color: AppColors.primary,),
                    Text(
                      "$gender",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// الأزرار
          Row(
            children: [
             


              // InkWell(
              //   onTap: onEdit,
              //   borderRadius: BorderRadius.circular(20),
              //   child: const Padding(
              //     padding: EdgeInsets.all(4),
              //     child: Icon(Icons.edit_outlined),
              //   ),
              // ),


              const SizedBox(height: 12),
               InkWell(
  borderRadius: BorderRadius.circular(20),
  onTap: () async {
  if (onSwitchAccount != null) {
    onSwitchAccount!();
    return;
  }

  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (_) => SwitchAccountBottomSheet(
      patients: patients,
      selectedPatientId: selectedPatientId,
      onPatientSelected: onPatientSelected,
    ),
  );

  if (result == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Account switched successfully".tr()),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
},
//   onTap: () {
//     // ================================
//     // MODIFIED
//     // ================================
//     if (onSwitchAccount != null) {
//       onSwitchAccount!();
//       return;
//     }
//     // showModalBottomSheet(
//     //   context: context,
//     //   shape: const RoundedRectangleBorder(
//     //     borderRadius: BorderRadius.vertical(
//     //       top: Radius.circular(24),
//     //     ),
//     //   ),
//     //   builder: (_) => SwitchAccountBottomSheet(
//     //     patients: patients,
//     //     selectedPatientId: selectedPatientId,
//     //     onPatientSelected: onPatientSelected,
//     //   ),
//     // );
// //     final result = await showModalBottomSheet<bool>(
// //   context: context,
// //   builder: (_) => SwitchAccountBottomSheet(
// //     patients: patients,
// //     selectedPatientId: selectedPatientId,
// //     onPatientSelected: onPatientSelected,
// //   ),
// // );

// // if (result == true && context.mounted) {
// //   ScaffoldMessenger.of(context).showSnackBar(
// //     SnackBar(
// //       content: Text("تم تبديل الحساب بنجاح"),
// //       behavior: SnackBarBehavior.floating,
// //       duration: const Duration(seconds: 2),
// //     ),
// //   );
// // }
// () async {
//   final result = await showModalBottomSheet<bool>(
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//         top: Radius.circular(24),
//       ),
//     ),
//     builder: (_) => SwitchAccountBottomSheet(
//       patients: patients,
//       selectedPatientId: selectedPatientId,
//       onPatientSelected: onPatientSelected,
//     ),
//   );

//   if (result == true && context.mounted) {
//     ScaffoldMessenger.of(context).showSnackBar(
//        SnackBar(
//         content: Text("Account switched successfully".tr()),
//         behavior: SnackBarBehavior.floating,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
// };
//     // ================================
//     // MODIFIED END
//     // ================================
//   },
  child: const Padding(
    padding: EdgeInsets.all(6),
    child: Icon(Icons.keyboard_arrow_down_rounded),
  ),
),
            ],
          ),
        ],
      ),
    );
  }
}
