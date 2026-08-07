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

  /// اسم الراوت لحتى نقدر نرجّع له من مسار الحجز بدون ما نطلع
  /// لشاشات الأونبوردنغ/اللغة/تسجيل الدخول يلي تحتها بالستاك.
  static const String routeName = '/main';

  /// index تبويب "مواعيدي" بنفس ترتيب IndexedStack / الناف بار.
  static const int appointmentsTabIndex = 1;

  /// بيتنادى من فوق مسار الحجز بعد التأكيد حتى نرجع للناف ونفتح مواعيدي.
  static void goToAppointmentsTab() {
    _MainNavigationPageState._instance?._goToTab(appointmentsTabIndex);
  }

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  static _MainNavigationPageState? _instance;

  // بتبلش الشاشة عالرئيسية (نفس index العنصر المبرز بالناف بار).
  int _currentIndex = AppBottomNavBar.emphasizedIndex;

  // بيزيد وحدة كل ما ندخل عالرئيسية - منمررها كـ key لكارد الخطة
  // العلاجية بالرئيسية حتى يعيد أنيميشن شريط التقدم من الصفر كل مرة
  // (بدل ما يشتغل مرة وحدة بس أول ما تفتح التطبيق).
  int _homeVisitCount = 0;

  // نفس ترتيب أيقونات AppBottomNavBar بالظبط.
  static const List<String> _tabTitleKeys = [
    'My Profile',
    'My Appointments',
    'Home',
    'My Treatment Plans',
    'Promotional Gallery',
  ];

  @override
  void initState() {
    super.initState();
    _instance = this;
  }

  @override
  void dispose() {
    if (_instance == this) _instance = null;
    super.dispose();
  }

  void _goToTab(int index) {
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
      if (index == AppBottomNavBar.emphasizedIndex) {
        _homeVisitCount++;
      }
    });
  }

  void _onTabTapped(int index) {
    _goToTab(index);
  }

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

          HomePage(homeVisitCount: _homeVisitCount), // الرئيسية
          _PlaceholderTab(titleKey: _tabTitleKeys[3]), // خططي العلاجية
          const PromotionalGalleryPage(), // المعرض التسويقي
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
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
