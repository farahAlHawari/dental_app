import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/profile/presentation/widgets/switch_account.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String gender;
  final String imagePath;

  final VoidCallback? onEdit;
  final VoidCallback? onSwitchAccount;

  const ProfileCard({
    super.key,
    required this.name,
    required this.gender,
    required this.imagePath,
    this.onEdit,
    this.onSwitchAccount,
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
          /// الصورة
          CircleAvatar(
            radius: 34,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: CircleAvatar(
              radius: 31,
              backgroundImage: AssetImage(imagePath),
            ),
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
  onTap: () {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) => const SwitchAccountBottomSheet(),
    );
  },
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