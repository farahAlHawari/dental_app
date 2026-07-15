import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/radiograph_viewer_page.dart';
import 'package:flutter/material.dart';

class RadiographCard extends StatefulWidget {
  const RadiographCard({super.key, required this.image, required this.title, required this.treatment, required this.date});
 final String image;
  final String title;
  final String treatment;
  final String date;

  @override
  State<RadiographCard> createState() => _RadiographCardState();
}

class _RadiographCardState extends State<RadiographCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => RadiographViewerPage(
        image: widget.image,
        title: widget.title,
        treatment:widget.treatment,
        date:widget.date
      ),
    ),
  );
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
                      Padding(
  padding: const EdgeInsets.all(8),
  child: Container(
    width: 110,
    height: 120,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Image.asset(
      widget.image,
      fit: BoxFit.cover,
    ),
  ),
),
                      // LottieBuilder.asset("assets/animations/3.json",width: 100,repeat: true,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                         
                          // Title
                          Text(
                                 widget.title,
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
                                     widget.treatment,
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
                                     widget.date,
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
           );
  }
}