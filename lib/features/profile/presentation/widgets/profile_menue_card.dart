// import 'package:dental_app/core/theme/app_colors.dart';
// import 'package:flutter/material.dart';

// class ProfileMenuCard extends StatelessWidget {
//   final String title;
//   final Icon icon;
//   final VoidCallback? onTap;

//   final Color backgroundColor;
//   final Color textColor;
//   final bool showArrow;

//   const ProfileMenuCard({
//     super.key,
//     required this.title,
//     required this.icon,
//     this.onTap,
//     this.backgroundColor = Theme.of(context).colorScheme.surfaceAppColors.surface,
//     this.textColor = Theme.of(context).colorScheme.onSurface,
//     this.showArrow = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(18),
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 18,
//           vertical: 18,
//         ),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: Theme.of(context).colorScheme.shadow,
//               blurRadius: 10,
//               offset: const Offset(0, 3),
//             )
//           ],
//         ),
//         child: Row(
//           children: [
//             icon,

//             const SizedBox(width: 16),

//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: textColor,
//                 ),
//               ),
//             ),

//             if (showArrow)
//               Icon(
//                 Icons.arrow_forward_ios_rounded,
//                 color: textColor.withOpacity(.6),
//                 size: 18,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ProfileMenuCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final VoidCallback? onTap;

  final Color? backgroundColor;
  final Color? textColor;
  final bool showArrow;

  const ProfileMenuCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackground =
        backgroundColor ?? Theme.of(context).colorScheme.surface;
    final effectiveTextColor =
        textColor ?? Theme.of(context).colorScheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: effectiveBackground,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.9),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: effectiveTextColor,
                ),
              ),
            ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: effectiveTextColor.withOpacity(.6),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}