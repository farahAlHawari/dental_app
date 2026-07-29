import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// معلومات جلسة واحدة قابلة للحجز ضمن خطة علاجية مفتوحة.
class BookableSession {
  final String title;
  final String description;
  final String planName;
  const BookableSession({
    required this.title,
    required this.description,
    required this.planName,
  });
}

class BookableSessionCard extends StatelessWidget {
  final BookableSession session;
  final VoidCallback onBook;
  const BookableSessionCard({
    super.key,
    required this.session,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // كانت color: colors.shadow بدون opacity - هيك بتطلع
            // أخف وأنسب لباقي الكاردات (نفس منطق كارد نوع الزيارة).
            color: colors.shadow.withOpacity(isDark ? 0.30 : 0.10),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // شارة اسم الخطة العلاجية يلي تابعة إلها الجلسة
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.folder_outlined, size: 13, color: colors.primary),
                  const SizedBox(width: 5),
                  Text(
                    session.planName,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            session.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            session.description,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: colors.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onBook,
              // icon: const Icon(
              //   Icons.arrow_forward,
              //   size: 16,
              //   color: Colors.white,
              // ),
              // "Book this session now" كانت موحية إنها حجز فوري，
              // بس هي فعلياً بتنقل عالخطوة الجاية (تاريخ ووقت) -
              // هيك النص أدق وبيماشي بقية أزرار الفلو.
              label: Text(
                'Select this session'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
