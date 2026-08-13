import 'package:dental_app/features/medical_archive/presentation/pages/my_treatment_journey_page.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/prescrptions_page.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/radiograph_page.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/reports_page.dart';
import 'package:dental_app/features/medical_archive/presentation/widgets/animated_tab_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MedicalArchivePage extends StatefulWidget {
  final int initialTabIndex;

  const MedicalArchivePage({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<MedicalArchivePage> createState() => _MedicalArchivePageState();
}

class _MedicalArchivePageState extends State<MedicalArchivePage> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialTabIndex.clamp(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'Radiographs'.tr(),
      'Reports'.tr(),
      'Prescriptions'.tr(),
      'My Treatment Journey'.tr(),
    ];

    final pages = const [
      RadiographPage(),
      ReportsPage(),
      PrescrptionsPage(),
      MyTreatmentJourneyPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medical Archive'.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/background1.png',
                color: Theme.of(context).colorScheme.primary,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AnimatedTabBar(
                    tabs: tabs,
                    selectedIndex: selectedIndex,
                    onChanged: (index) {
                      setState(() => selectedIndex = index);
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
                      child: KeyedSubtree(
                        key: ValueKey(selectedIndex),
                        child: pages[selectedIndex],
                      ),
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
