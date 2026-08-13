import 'package:dental_app/features/appointments/presentation/pages/my_appointments_page.dart';
import 'package:dental_app/features/home/presentation/pages/home_page.dart';
import 'package:dental_app/features/home/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:dental_app/features/profile/presentation/pages/profile_page.dart';
import 'package:dental_app/features/promotional_gallery/presentation/pages/promotional_gallery_page.dart';
import 'package:dental_app/features/treatment_plans/presentation/pages/treatment_plans_page.dart';
import 'package:flutter/material.dart';

/// Main shell after login — bottom nav + IndexedStack of feature tabs.
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  static const String routeName = '/main';

  static const int appointmentsTabIndex = 1;
  static const int homeTabIndex = AppBottomNavBar.emphasizedIndex;

  /// After booking confirmation: open appointments and refresh lists/home.
  static void goToAppointmentsTab() {
    _MainNavigationPageState._instance?._goToAppointmentsTab(refresh: true);
  }

  /// Bump refresh tokens so IndexedStack tabs reload remote data.
  static void notifyDataChanged() {
    _MainNavigationPageState._instance?._bumpRefreshTokens();
  }

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  static _MainNavigationPageState? _instance;

  int _currentIndex = AppBottomNavBar.emphasizedIndex;
  int _homeVisitCount = 0;
  int _appointmentsRefreshToken = 0;

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

  void _bumpRefreshTokens() {
    if (!mounted) return;
    setState(() {
      _appointmentsRefreshToken++;
      _homeVisitCount++;
    });
  }

  void _goToAppointmentsTab({bool refresh = false}) {
    if (!mounted) return;
    setState(() {
      _currentIndex = MainNavigationPage.appointmentsTabIndex;
      if (refresh) {
        _appointmentsRefreshToken++;
        _homeVisitCount++;
      }
    });
  }

  void _goToTab(int index) {
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
      if (index == MainNavigationPage.homeTabIndex) {
        _homeVisitCount++;
      }
    });
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
          const ProfilePage(),
          MyAppointmentsPage(refreshToken: _appointmentsRefreshToken),
          HomePage(homeVisitCount: _homeVisitCount),
          const TreatmentPlansPage(),
          const PromotionalGalleryPage(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _goToTab,
      ),
    );
  }
}
