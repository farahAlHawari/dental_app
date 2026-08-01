import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/features/promotional_gallery/presentation/widgets/gallery_post_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// تبويب "المعرض التسويقي" - فييد بوستات عرض بس (FR-P-09)، بلا أي
/// تفاعل. كل بوست: نص بس، أو صورة بس، أو صورة ونص سوا.
class PromotionalGalleryPage extends StatelessWidget {
  const PromotionalGalleryPage({super.key});

  // TODO: بيانات تجريبية لحد ما توصل الشاشة مع الـ backend الحقيقي.
  static const List<GalleryPost> _posts = [
    GalleryPost.beforeAfter(
      beforeImagePath: 'assets/images/before.png',
      afterImagePath: 'assets/images/after.png',
      text:
          'See the real result of our teeth whitening treatment. Drag the slider to compare before and after!',
    ),
    GalleryPost(
      text:
          "Did you know? Replacing your toothbrush every 3 months helps keep your gums healthy and prevents bacteria buildup.",
    ),
    GalleryPost(imagePath: 'assets/images/xray.jpg'),
    GalleryPost(
      imagePath: 'assets/images/after.png',
      text:
          'Special offer this month: 20% off teeth whitening sessions. Contact the clinic to book your appointment.',
    ),
    GalleryPost(
      text:
          'Reminder: regular check-ups every 6 months are key to catching dental issues early.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Promotional Gallery'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/background1.png',
                fit: BoxFit.cover,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SafeArea(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                itemCount: _posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) => FadeSlideIn(
                  delay: Duration(milliseconds: 60 * index),
                  child: GalleryPostCard(post: _posts[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
