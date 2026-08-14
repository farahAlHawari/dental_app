// import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// /// Formats notification `createdAt` for list rows.
// String formatNotificationDate(String? raw) {
//   if (raw == null || raw.trim().isEmpty) return '';
//   final dt = DateTime.tryParse(raw);
//   if (dt == null) return raw;
//   final local = dt.toLocal();
//   final now = DateTime.now();
//   final today = DateTime(now.year, now.month, now.day);
//   final day = DateTime(local.year, local.month, local.day);
//   final time = DateFormat.jm().format(local);
//   if (day == today) return '${'Today'.tr()} · $time';
//   if (day == today.subtract(const Duration(days: 1))) {
//     return '${'Yesterday'.tr()} · $time';
//   }
//   return '${DateFormat.yMMMd().format(local)} · $time';
// }

// class NotificationListItem extends StatelessWidget {
//   final String title;
//   final String body;
//   final String? createdAt;
//   final bool isRead;
//   final VoidCallback? onTap;

//   const NotificationListItem({
//     super.key,
//     required this.title,
//     required this.body,
//     this.createdAt,
//     required this.isRead,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final dateLabel = formatNotificationDate(createdAt);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(18),
//           child: Ink(
//             decoration: BoxDecoration(
//               color: isRead
//                   ? colors.surface.withValues(alpha: 0.92)
//                   : colors.primaryContainer.withValues(alpha: 0.55),
//               borderRadius: BorderRadius.circular(18),
//               border: Border.all(
//                 color: isRead
//                     ? colors.outlineVariant.withValues(alpha: 0.28)
//                     : colors.primary.withValues(alpha: 0.18),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: colors.shadow.withValues(alpha: 0.06),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(18),
//               child: IntrinsicHeight(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Container(
//                       width: 4,
//                       color: isRead ? Colors.transparent : colors.primary,
//                     ),
//                     Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(12, 14, 14, 14),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: 46,
//                             height: 46,
//                             padding: const EdgeInsets.all(7),
//                             decoration: BoxDecoration(
//                               color: colors.surface,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: colors.primary.withValues(alpha: 0.12),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: colors.primary.withValues(alpha: 0.08),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Image.asset(
//                               'assets/images/logo1.png',
//                               fit: BoxFit.contain,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   Icon(
//                                 Icons.medical_services_rounded,
//                                 color: colors.primary,
//                                 size: 22,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         title.isEmpty
//                                             ? 'Notification'.tr()
//                                             : title,
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           height: 1.25,
//                                           fontWeight: isRead
//                                               ? FontWeight.w600
//                                               : FontWeight.w700,
//                                           color: colors.onSurface,
//                                         ),
//                                       ),
//                                     ),
//                                     if (!isRead) ...[
//                                       const SizedBox(width: 8),
//                                       Container(
//                                         margin: const EdgeInsets.only(top: 5),
//                                         width: 8,
//                                         height: 8,
//                                         decoration: BoxDecoration(
//                                           color: colors.primary,
//                                           shape: BoxShape.circle,
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                                 if (body.isNotEmpty) ...[
//                                   const SizedBox(height: 5),
//                                   Text(
//                                     body,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       height: 1.4,
//                                       color: colors.onSurface
//                                           .withValues(alpha: 0.62),
//                                     ),
//                                   ),
//                                 ],
//                                 if (dateLabel.isNotEmpty) ...[
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     dateLabel,
//                                     style: TextStyle(
//                                       fontSize: 11.5,
//                                       fontWeight: FontWeight.w500,
//                                       color: colors.onSurface
//                                           .withValues(alpha: 0.42),
//                                     ),
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NotificationsListShimmer extends StatelessWidget {
//   const NotificationsListShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
//       itemCount: 6,
//       itemBuilder: (context, index) => Padding(
//         padding: const EdgeInsets.only(bottom: 10),
//         child: AppShimmer(
//           child: Container(
//             height: 96,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(18),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Formats notification `createdAt` for list rows.
String formatNotificationDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) return '';
  final dt = DateTime.tryParse(raw);
  if (dt == null) return raw;
  final local = dt.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  final time = DateFormat.jm().format(local);
  if (day == today) return '${'Today'.tr()} · $time';
  if (day == today.subtract(const Duration(days: 1))) {
    return '${'Yesterday'.tr()} · $time';
  }
  return '${DateFormat.yMMMd().format(local)} · $time';
}

class NotificationListItem extends StatelessWidget {
  final String title;
  final String body;
  final String? createdAt;
  final bool isRead;
  final VoidCallback? onTap;

  const NotificationListItem({
    super.key,
    required this.title,
    required this.body,
    this.createdAt,
    required this.isRead,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateLabel = formatNotificationDate(createdAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: colors.primary.withValues(alpha: 0.06),
          highlightColor: colors.primary.withValues(alpha: 0.04),
          child: Ink(
            decoration: BoxDecoration(
              // غير مقروءة: خلفية شفافة بلون العلامة التجارية — تلفت الانتباه فوراً.
              // مقروءة: بيضاء نظيفة تماماً — الهدوء نفسه هو الإشارة إنها "قديمة".
              color: isRead
                  ? colors.surface
                  : (isDark
                      ? AppColors.CardDark.withValues(alpha: 0.5)
                      : AppColors.CardLight.withValues(alpha: 0.55)),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isRead
                    ? colors.outlineVariant.withValues(alpha: 0.2)
                    : colors.primary.withValues(alpha: 0.22),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: isDark ? 0.16 : 0.045),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BellAvatar(isRead: isRead),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                title.isEmpty ? 'Notification'.tr() : title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  height: 1.3,
                                  fontWeight:
                                      isRead ? FontWeight.w600 : FontWeight.w700,
                                  letterSpacing: -0.1,
                                  color: colors.onSurface,
                                ),
                              ),
                            ),
                            if (!isRead) ...[
                              const SizedBox(width: 8),
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (body.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.42,
                              color: colors.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                        if (dateLabel.isNotEmpty) ...[
                          const SizedBox(height: 9),
                          Text(
                            dateLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: colors.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// أيقونة الجرس بهوية اللوغو: تدرج teal → فضي (نفس ألوان شعار Wenni)،
/// مع بريق صغير (sparkle) بنفس روح اللوغو. تخفت لدرجة رمادية هادئة
/// بعد القراءة.
class _BellAvatar extends StatelessWidget {
  final bool isRead;

  const _BellAvatar({required this.isRead});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isRead
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.summaryCardDarkStart,
                              AppColors.summaryCardDarkEnd,
                            ]
                          : [
                              AppColors.summaryCardLightStart,
                              AppColors.summaryCardLightEnd,
                            ],
                    ),
              color: isRead ? colors.surfaceContainerHighest : null,
              boxShadow: isRead
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.notifications_rounded,
              size: 20,
              color: isRead
                  ? colors.onSurface.withValues(alpha: 0.38)
                  : Colors.white,
            ),
          ),
          if (!isRead)
            Positioned(
              top: -2,
              right: -2,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 12,
                color: AppColors.primary.withValues(alpha: 0.85),
              ),
            ),
        ],
      ),
    );
  }
}

class NotificationsListShimmer extends StatelessWidget {
  const NotificationsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: AppShimmer(
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}