import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VisitCard extends StatelessWidget {
  final String title;
  final String dateLabel;
  final String timeLabel;
  final String? planName;
  final int? rating;
  final bool canRate;
  final VoidCallback? onRatePressed;

  const VisitCard({
    super.key,
    required this.title,
    required this.dateLabel,
    required this.timeLabel,
    this.planName,
    this.rating,
    this.canRate = false,
    this.onRatePressed,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Completed'.tr(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (planName != null && planName!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: 16,
                  color: onSurface.withOpacity(0.45),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${'Treatment plan'.tr()}: $planName',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: onSurface.withOpacity(0.65),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                dateLabel,
                style: TextStyle(
                  color: onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                timeLabel,
                style: TextStyle(
                  color: onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          if (canRate || rating != null) ...[
            const Divider(height: 24),
            if (canRate)
              InkWell(
                onTap: onRatePressed,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    LottieBuilder.asset(
                      'assets/animations/star.json',
                      width: 40,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Rate your visit'.tr(),
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    color: index < (rating ?? 0)
                        ? Colors.amber
                        : Colors.grey.shade300,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
