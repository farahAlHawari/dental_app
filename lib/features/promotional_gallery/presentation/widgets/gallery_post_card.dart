import 'package:dental_app/core/widgets/before_after_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// بوست وحدة بالمعرض التسويقي. لازم نص أو صورة عالأقل (ممكن الاتنين
/// سوا)، أو بوست "قبل/بعد" (سلايدر مقارنة) عبر [GalleryPost.beforeAfter].
/// ما في أي حقل تفاعل (لايك/تعليق) لإنه المريض بس بيشوف، ما بيعمل
/// أي إجراء - متطابق مع الوصف يلي حكيتيه.
class GalleryPost {
  final String? text;
  final String? imagePath;
  final String? beforeImagePath;
  final String? afterImagePath;

  const GalleryPost({this.text, this.imagePath})
    : beforeImagePath = null,
      afterImagePath = null,
      assert(
        text != null || imagePath != null,
        'لازم يكون في نص أو صورة عالأقل بكل بوست',
      );

  /// بوست "قبل/بعد" - عرض نتيجة علاج فعلية بسلايدر تفاعلي للمقارنة،
  /// بدل صورة ثابتة وحدة. النص هون اختياري ومنعرضه كتعليق تحت السلايدر.
  const GalleryPost.beforeAfter({
    this.text,
    required this.beforeImagePath,
    required this.afterImagePath,
  }) : imagePath = null;

  bool get isBeforeAfter => beforeImagePath != null && afterImagePath != null;
}

/// كارد عرض بوست وحدة - عرض بس، بدون أي زر أو إجراء.
class GalleryPostCard extends StatelessWidget {
  final GalleryPost post;

  const GalleryPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final hasImage = post.imagePath != null;
    final hasText = post.text != null && post.text!.trim().isNotEmpty;
    final isBeforeAfter = post.isBeforeAfter;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(isDark ? 0.30 : 0.10),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // هيدر بسيط بهوية العيادة - عرض فقط، ما في أي إجراء عليه.
          // بدّلي "Our Clinic" بالترجمة الفعلية لاسم عيادتكن بملفات اللغة.
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_hospital_rounded,
                    size: 18,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Our Clinic'.tr(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (isBeforeAfter)
            AspectRatio(
              aspectRatio: 4 / 3,
              child: BeforeAfterSlider(
                beforeImagePath: post.beforeImagePath!,
                afterImagePath: post.afterImagePath!,
                // بلا راديوس هون - الكارد نفسه عم يقص الزوايا (Clip.antiAlias
                // فوق)، متل ما عم يصير بالصورة العادية تماماً.
                borderRadius: 0,
              ),
            )
          else if (hasImage)
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.asset(post.imagePath!, fit: BoxFit.cover),
            ),
          // لو ما في نص (والحالة الوحيدة الممكنة هون إنه في صورة أو
          // سلايدر قبل/بعد، حسب الـ constructors فوق)، ما منضيف أي
          // مسافة بعد المحتوى - بيوصل لآخر الكارد مباشرة (وزواياه
          // بتنقص تلقائياً مع زوايا الكارد الدائرية بفضل الـ
          // clipBehavior فوق)، بدل فراغ فاضي بلا داعي.
          if (hasText)
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                post.text!.tr(),
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: colors.onSurface.withOpacity(0.8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
