import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/medical_archive/presentation/widgets/radiograph_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RadiographPage extends StatefulWidget {
  const RadiographPage({super.key});

  @override
  State<RadiographPage> createState() => _RadiographPageState();
}

class _RadiographPageState extends State<RadiographPage> {

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
         return Padding(
           padding: const EdgeInsets.all(10),
           child: 
            RadiographCard(
      image: "assets/images/xray.jpg",
      title: "Jaw X-Ray",
      treatment: "Root Canal Treatment",
      date: "Tuesday 5/10/2026",
    )
           
         );
        }),
      ),
    );
  }
}