import 'package:dental_app/core/utils/patient_profile_image.dart';
import 'package:flutter/material.dart';

/// Patient photo from API, or person icon when missing / load fails.
class PatientAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color? backgroundColor;
  final Color? iconColor;

  const PatientAvatar({
    super.key,
    this.imageUrl,
    this.radius = 28,
    this.backgroundColor,
    this.iconColor,
  });

  /// Builds from a patient map (`profileImage.url`).
  factory PatientAvatar.fromPatient(
    Map<String, dynamic>? patient, {
    Key? key,
    double radius = 28,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return PatientAvatar(
      key: key,
      imageUrl: PatientProfileImage.urlOf(patient),
      radius: radius,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final bg = backgroundColor ?? primary.withOpacity(0.15);
    final icon = iconColor ?? primary;
    final resolved = PatientProfileImage.resolve(imageUrl);

    if (resolved == null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        child: Icon(Icons.person, size: radius * 0.95, color: icon),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      child: ClipOval(
        child: Image.network(
          resolved,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: Icon(Icons.person, size: radius * 0.95, color: icon),
          ),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return SizedBox(
              width: radius * 2,
              height: radius * 2,
              child: Center(
                child: SizedBox(
                  width: radius * 0.6,
                  height: radius * 0.6,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: icon,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
