import 'package:before_after/before_after.dart';
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BeforeAfterCard extends StatefulWidget {
  const BeforeAfterCard({super.key});

  @override
  State<BeforeAfterCard> createState() => _BeforeAfterCardState();
}

class _BeforeAfterCardState extends State<BeforeAfterCard> {
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(150),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Teeth Whitening".tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            AspectRatio(
              aspectRatio: 16 / 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                   
                    Positioned.fill(
                      child: BeforeAfter(
                        value: _sliderValue,
                        onValueChanged: (value) {
                          setState(() => _sliderValue = value);
                        },
                        thumbColor: AppColors.primary,
                        trackColor: AppColors.primary,
                        before: SizedBox.expand(
                          child: Image.asset(
                            "assets/images/after.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        after: SizedBox.expand(
                          child: Image.asset(
                            "assets/images/before.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    
                    Positioned(
                      top: 10,
                      left: 10,
                      child: _ImageTag(text: "Before".tr()),
                    ),

                    
                    Positioned(
                      top: 10,
                      right: 10,
                      child: _ImageTag(text: "After".tr()),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Professional teeth whitening completed successfully.\nSwipe the slider to compare the result.".tr(),
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 10),

            Text(
              "12 May 2027",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Badge صغير لكتابة Before / After فوق الصورة
// ------------------------------------------------------------
class _ImageTag extends StatelessWidget {
  final String text;

  const _ImageTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}