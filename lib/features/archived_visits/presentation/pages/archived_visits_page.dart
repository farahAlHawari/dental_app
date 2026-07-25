// import 'package:dental_app/core/theme/app_colors.dart';
// import 'package:flutter/material.dart';

// class ArchivedVisitsPage extends StatefulWidget {
//   const ArchivedVisitsPage({super.key});

//   @override
//   State<ArchivedVisitsPage> createState() => _ArchivedVisitsPageState();
// }

// class _ArchivedVisitsPageState extends State<ArchivedVisitsPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// List<String> titles = [
//   'Root Canal Treatment',   // سحب عصب
//   'Tooth Extraction',       // قلع سن
//   'Dental Cleaning & Checkup',
//   'Teeth Whitening',
//   'Dental Filling',
//   'Clear Aligner Fitting',
//   'Dental Implant',
//   'Wisdom Tooth Removal',
// ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(
//             'Archived Visits',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primary,
//             ),
//           ),),
//       backgroundColor: const Color.fromARGB(255, 222, 235, 240),
//       body: SizedBox.expand(
        
//         child: Stack(
//           children: [
//             Positioned.fill(
//                 child: Image.asset('assets/backgrounds/7.png',color: AppColors.primary, 
//                  fit: BoxFit.cover,),
//               ),
//               Column(
//                 children: [
//                   Expanded(child: ListView.builder(itemCount: titles.length,
//                     itemBuilder: (context,index){
//                     return Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Container(
//                         height: 150,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           // border: Border.all(color: AppColors.primary),
//                           color: const Color.fromARGB(255, 239, 244, 246),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                                 BoxShadow(
//                                   color: const Color.fromARGB(233, 33, 113, 145),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
                      
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(titles[index],style: TextStyle(
//                                 color: AppColors.textPrimary,
//                                 fontSize: 20,fontWeight: FontWeight.w600
                                                
//                               ),),
//                               SizedBox(height: 10,),
//                               Row(
//                                 children: [
//                                   Icon(Icons.calendar_today_outlined,color: AppColors.primary,size: 18,),
//                                   SizedBox(width: 10,),
//                                   Text("Monday 5/10/2027",style: TextStyle(
//                                     color: AppColors.textPrimary,
//                                     fontSize: 10,fontWeight: FontWeight.w400
                                    
//                                   ),),
//                                 ],
//                               ),
//                               SizedBox(height: 10,),
//                               Row(
//                                 children: [
//                                   Icon(Icons.access_time,color: AppColors.primary,size: 18,),
//                                   SizedBox(width: 10,),
//                                   Text("9:00 PM",style: TextStyle(
//                                     color: AppColors.textPrimary,
//                                     fontSize: 10,fontWeight: FontWeight.w400
                                    
//                                   ),),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   } )
//                   )
//                 ],
//               )
//           ],
         
//         ),
//       ),
//     );
//   }
// }

import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/archived_visits/presentation/widgets/ratingDialog.dart';
import 'package:dental_app/features/archived_visits/presentation/widgets/visit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ArchivedVisitsPage extends StatefulWidget {
  const ArchivedVisitsPage({super.key});

  @override
  State<ArchivedVisitsPage> createState() => _ArchivedVisitsPageState();
}

class _ArchivedVisitsPageState extends State<ArchivedVisitsPage> {
  final List<String> titles = [
    'Root Canal Treatment', // سحب عصب
    'Tooth Extraction', // قلع سن
    'Dental Cleaning & Checkup',
    'Teeth Whitening',
    'Dental Filling',
    'Clear Aligner Fitting',
    'Dental Implant',
    'Wisdom Tooth Removal',
  ];
final Map<int, int> ratings = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Archived Visits',
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
                'assets/backgrounds/7.png',
                color: Theme.of(context).colorScheme.primary,
                fit: BoxFit.cover,
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: VisitCard(
  title: titles[index],
  date: 'Monday 5/10/2027',
  time: '9:00 PM',
  rating: ratings[index],

  onRated: (value) {
    setState(() {
      ratings[index] = value;
    });
  },

  onRatePressed: () async {

    final result = await showDialog<int>(
      context: context,
      builder: (_) => const RatingDialog()
    );

    if (result != null) {
      setState(() {
        ratings[index] = result;
      });
    }
  },
),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
