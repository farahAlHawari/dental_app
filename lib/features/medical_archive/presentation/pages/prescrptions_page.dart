import 'package:dental_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PrescrptionsPage extends StatefulWidget {
  const PrescrptionsPage({super.key});

  @override
  State<PrescrptionsPage> createState() => _PrescrptionsPageState();
}

class _PrescrptionsPageState extends State<PrescrptionsPage> {

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
           child: InkWell(
            onTap: () {
              
            },
             child: Container(
              
                  width: double.infinity,
                  // padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 248, 249),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
             color: const Color.fromARGB(137, 33, 113, 145),
             blurRadius: 10,
             offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      LottieBuilder.asset("assets/animations/3.json",width: 100,repeat: true,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                         
                          // Title
                          Text(
                                 "Perscription1",
                                 style: TextStyle(
                                   color: AppColors.textPrimary,
                                   fontSize: 18,
                                   fontWeight: FontWeight.w600,
                                 ),
                          ),
                          const SizedBox(height: 10),
                         
                          // Date
                          Row(
                                 children: [
                                   Icon(Icons.medical_information_outlined, color: AppColors.primary, size: 16),
                                   const SizedBox(width: 8),
                                   Text(
                                     "Root Canal Treatment",
                                     style: TextStyle(
                       color: AppColors.textPrimary,
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
                                   Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 16),
                                   const SizedBox(width: 8),
                                   Text(
                                     "Tuesday 5/10/2026",
                                     style: TextStyle(
                       color: AppColors.textPrimary,
                       fontSize: 13,
                       fontWeight: FontWeight.w400,
                                     ),
                                   ),
                                 ],
                          ),
                       
                         
                      
                        ],
                      ),
                    ],
                  ),
                ),
           ),
         );
        }),
      ),
    );
  }
}