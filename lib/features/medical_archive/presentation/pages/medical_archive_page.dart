import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/my_treatment_journey_page.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/prescrptions_page.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/radiograph_page.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/reports_page.dart';
import 'package:dental_app/features/medical_archive/presentation/widgets/animated_tab_bar.dart';
import 'package:dental_app/features/medical_archive/presentation/widgets/medical_tabview_widget.dart';
import 'package:flutter/material.dart';



class MedicalArchivePage extends StatefulWidget {
  const MedicalArchivePage({super.key});

  @override
  State<MedicalArchivePage> createState() => _MedicalArchivePageState();
}

class _MedicalArchivePageState extends State<MedicalArchivePage> {

  int selectedIndex = 0;

  final List<String> tabs = [
    "Radiographs",
    "Reports",
    "Prescriptions",
    "My Treatment\nJourney"
  ];

final pages = [
  const RadiographPage(),
  const ReportsPage(),
  const PrescrptionsPage(),
  const MyTreatmentJourneyPage(),
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: const Text("Medical Archive",style: TextStyle(
          color: AppColors.primary,
          fontSize: 20,
          fontWeight: FontWeight.w600
        ),),
      ),

      body: SizedBox.expand(

        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/backgrounds/background1.png',color: Theme.of(context).colorScheme.primary, 
               fit: BoxFit.cover,),
            ),
            Padding(
            padding: const EdgeInsets.all(16),
          
            child: Column(
          
              children: [
          
                AnimatedTabBar(
                  tabs: tabs,
                  selectedIndex: selectedIndex,
                  onChanged: (index) {
          
                    setState(() {
          
                      selectedIndex = index;
          
                    });
          
                  },
                ),
          
                const SizedBox(height: 20),
          
                Expanded(
          
                  child: AnimatedSwitcher(
          
                    duration: const Duration(milliseconds: 350),
          
                    transitionBuilder: (child, animation) {
          
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
          
                    },
          
                    child: pages[selectedIndex],
          
                  ),
          
                ),
          
              ],
          
            ),
          
          ),
          ],
          
        ),
      ),

    );
  }

  

}