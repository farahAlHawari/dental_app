import 'package:dental_app/features/appointments/presentation/pages/my_appointments_page.dart';
import 'package:dental_app/features/home/presentation/pages/home_page.dart';
import 'package:dental_app/features/home/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:dental_app/features/profile/presentation/pages/profile_page.dart';
import 'package:dental_app/features/promotional_gallery/presentation/pages/promotional_gallery_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// إطار التطبيق الرئيسي بعد تسجيل الدخول - بيحمل الناف بار السفلي
/// وبيبدّل بين 5 تبويبات. الصفحات هلق مجرد مكان محجوز (placeholder)؛
/// كل تبويب رح ياخد شاشته الحقيقية لاحقاً.
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  // بتبلش الشاشة عالرئيسية (نفس index العنصر المبرز بالناف بار).
  int _currentIndex = AppBottomNavBar.emphasizedIndex;

  // نفس ترتيب أيقونات AppBottomNavBar بالظبط.
  static const List<String> _tabTitleKeys = [
    'My Profile',
    'My Appointments',
    'Home',
    'My Treatment Plans',
    'Promotional Gallery',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerHighest,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const ProfilePage(), // ملفي الشخصي - جاهزة
          const MyAppointmentsPage(), // مواعيدي - جاهزة

          const HomePage(), // الرئيسية
          _PlaceholderTab(titleKey: _tabTitleKeys[3]), // خططي العلاجية
          const PromotionalGalleryPage(), // المعرض التسويقي
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

/// مكان محجوز مؤقت لحد ما تبني كل تبويب شاشته الفعلية.
class _PlaceholderTab extends StatelessWidget {
  final String titleKey;

  const _PlaceholderTab({required this.titleKey});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        titleKey.tr(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colors.onSurface,
        ),
      ),
    );
  }
}
