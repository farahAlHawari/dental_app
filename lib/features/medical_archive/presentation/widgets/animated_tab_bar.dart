import 'package:dental_app/features/medical_archive/presentation/widgets/tab_botton.dart';
import 'package:flutter/material.dart';


class AnimatedTabBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> tabs;
  final ValueChanged<int> onChanged;

  const AnimatedTabBar({
    super.key,
    required this.selectedIndex,
    required this.tabs,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xffECECEC),
        borderRadius: BorderRadius.circular(30),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(
            tabs.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: SizedBox(
                width: 120, // عرض كل تاب
                child: TabButton(
                  text: tabs[index],
                  selected: selectedIndex == index,
                  onTap: () => onChanged(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}