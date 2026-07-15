import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/medical_archive/presentation/widgets/before_after_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyTreatmentJourneyPage extends StatefulWidget {
  const MyTreatmentJourneyPage({super.key});

  @override
  State<MyTreatmentJourneyPage> createState() => _MyTreatmentJourneyPageState();
}

class _MyTreatmentJourneyPageState extends State<MyTreatmentJourneyPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 223, 227),
        borderRadius: BorderRadius.circular(25),
        
      ),
      child: Expanded(
        child: ListView.builder(itemCount: 10,
         itemBuilder: (context,index){
         return BeforeAfterCard();
        }),
      ),
    );
  }
}