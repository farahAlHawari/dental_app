import 'package:dental_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VisitCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final VoidCallback onRatePressed;
    final ValueChanged<int> onRated;
final int? rating;
  const VisitCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.onRatePressed,
    required this.onRated,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
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
         

          // Title
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          // Date
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: Theme.of(context).colorScheme.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                date,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Time
          Row(
            children: [
              Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          // Rate your visit
          rating == null
    ? InkWell(
        onTap: onRatePressed,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            LottieBuilder.asset(
              "assets/animations/star.json",
              width: 40,
            ),
            const SizedBox(width: 5),
            Text(
              "Rate your visit",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      )
    : Row(
        children: List.generate(
          5,
          (index) => Icon(
            Icons.star,
            color:
                index < rating! ? Colors.amber : Colors.grey.shade300,
          ),
        ),
      ),
        ],
      ),
    );
  }
}
