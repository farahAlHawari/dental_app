import 'package:dental_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          LottieBuilder.asset("assets/animations/4.json",width: 170,repeat: true,),
           Text("Rate this visit"),
        ],
      ),

      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return IconButton(
            onPressed: () {
              setState(() {
                rating = index + 1;
              });
            },
            icon: Icon(
              Icons.star,
              color: index < rating ? AppColors.primary : Colors.grey,
            ),
          );
        }),
      ),

      actions: [
        TextButton(
          
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, rating); // يرجع القيمة
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}