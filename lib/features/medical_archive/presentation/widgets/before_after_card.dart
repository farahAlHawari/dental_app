import 'package:dental_app/core/widgets/before_after_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// كارد "قبل/بعد" بعنوان ووصف وتاريخ - مستخدم بصفحة "رحلتي العلاجية".
/// نفس سلايدر المقارنة (BeforeAfterSlider) مستخدم كمان بالمعرض التسويقي
/// لإبقاء الشكل موحّد بين الشاشتين.
class BeforeAfterCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String beforeImagePath;
  final String afterImagePath;

  const BeforeAfterCard({
    super.key,
    this.title = 'Teeth Whitening',
    this.description =
        'Professional teeth whitening completed successfully.\n'
        'Swipe the slider to compare the result.',
    this.date = '12 May 2027',
    this.beforeImagePath = 'assets/images/before.png',
    this.afterImagePath = 'assets/images/after.png',
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            AspectRatio(
              aspectRatio: 16 / 10,
              child: BeforeAfterSlider(
                beforeImagePath: beforeImagePath,
                afterImagePath: afterImagePath,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              description.tr(),
              style: TextStyle(fontSize: 14, color: colors.onSurface.withOpacity(0.8)),
            ),

            const SizedBox(height: 10),

            Text(date, style: TextStyle(color: colors.onSurface.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }
}
