// import 'dart:ui' as ui;

// import 'package:dental_app/core/notifications/device_token_sync.dart';
// import 'package:dental_app/core/widgets/custom_confirmation_dialog.dart';
// import 'package:dental_app/features/appointments/presentation/pages/my_appointments_page.dart';
// import 'package:dental_app/features/home/presentation/pages/home_page.dart';
// import 'package:dental_app/features/home/presentation/widgets/app_bottom_nav_bar.dart';
// import 'package:dental_app/features/profile/presentation/pages/profile_page.dart';
// import 'package:dental_app/features/promotional_gallery/presentation/pages/promotional_gallery_page.dart';
// import 'package:dental_app/features/treatment_plans/presentation/pages/treatment_plans_page.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// /// Main shell after login — bottom nav + IndexedStack of feature tabs.
// class MainNavigationPage extends StatefulWidget {
//   const MainNavigationPage({super.key});

//   static const String routeName = '/main';

//   static const int appointmentsTabIndex = 1;
//   static const int homeTabIndex = AppBottomNavBar.emphasizedIndex;

//   /// After booking confirmation: open appointments and refresh lists/home.
//   static void goToAppointmentsTab() {
//     _MainNavigationPageState._instance?._goToAppointmentsTab(refresh: true);
//   }

//   static void goToHomeTab() {
//     _MainNavigationPageState._instance?._goToTab(homeTabIndex);
//   }

//   /// Bump refresh tokens so IndexedStack tabs reload remote data.
//   static void notifyDataChanged() {
//     _MainNavigationPageState._instance?._bumpRefreshTokens();
//   }

//   static Widget homeTabBackButton(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
//     return IconButton(
//       tooltip: MaterialLocalizations.of(context).backButtonTooltip,
//       icon: Icon(
//         isRtl ? Icons.arrow_forward : Icons.arrow_back,
//         color: colors.primary,
//       ),
//       onPressed: goToHomeTab,
//     );
//   }

//   @override
//   State<MainNavigationPage> createState() => _MainNavigationPageState();
// }

// class _MainNavigationPageState extends State<MainNavigationPage>
//     with WidgetsBindingObserver {
//   static _MainNavigationPageState? _instance;

//   int _currentIndex = AppBottomNavBar.emphasizedIndex;
//   int _homeVisitCount = 0;
//   int _appointmentsRefreshToken = 0;
//   int _appointmentsUpcomingToken = 0;

//   /// بيزيد أول ما تفتح الشاشة وكل ما التطبيق يرجع resume — بيفعّل
//   /// فحص الـ pending rating بكارد الرئيسية.
//   int _ratingCheckTick = 1;

//   @override
//   void initState() {
//     super.initState();
//     _instance = this;
//     WidgetsBinding.instance.addObserver(this);
//     // Register FCM with backend for this authenticated session.
//     DeviceTokenSync.registerCurrentToken();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     if (_instance == this) _instance = null;
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       if (!mounted) return;
//       setState(() => _ratingCheckTick++);
//     }
//   }

//   void _bumpRefreshTokens() {
//     if (!mounted) return;
//     setState(() {
//       _appointmentsRefreshToken++;
//       _homeVisitCount++;
//     });
//   }

//   void _goToAppointmentsTab({bool refresh = false}) {
//     if (!mounted) return;
//     setState(() {
//       _currentIndex = MainNavigationPage.appointmentsTabIndex;
//       _appointmentsUpcomingToken++;
//       if (refresh) {
//         _appointmentsRefreshToken++;
//         _homeVisitCount++;
//       }
//     });
//   }

//   void _goToTab(int index) {
//     if (!mounted) return;
//     setState(() {
//       _currentIndex = index;
//       if (index == MainNavigationPage.homeTabIndex) {
//         _homeVisitCount++;
//       }
//     });
//   }

//   Future<void> _onSystemBack() async {
//     if (_currentIndex != MainNavigationPage.homeTabIndex) {
//       _goToTab(MainNavigationPage.homeTabIndex);
//       return;
//     }

//     CustomConfirmationDialog.show(
//       context,
//       title: 'Exit the app'.tr(),
//       description: 'Do you want to exit the app?'.tr(),
//       confirmButtonText: 'Yes'.tr(),
//       cancelButtonText: 'No'.tr(),
//       isDestructive: true,
//       onCancel: () => Navigator.of(context).pop(),
//       onConfirm: () {
//         Navigator.of(context).pop();
//         SystemNavigator.pop();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, _) {
//         if (didPop) return;
//         _onSystemBack();
//       },
//       child: Scaffold(
//         backgroundColor: colors.surfaceContainerHighest,
//         extendBody: true,
//         body: IndexedStack(
//           index: _currentIndex,
//           children: [
//             const ProfilePage(),
//             MyAppointmentsPage(
//               refreshToken: _appointmentsRefreshToken,
//               upcomingTabToken: _appointmentsUpcomingToken,
//             ),
//             HomePage(
//               homeVisitCount: _homeVisitCount,
//               ratingCheckTick: _ratingCheckTick,
//             ),
//             const TreatmentPlansPage(),
//             const PromotionalGalleryPage(),
//           ],
//         ),
//         bottomNavigationBar: AppBottomNavBar(
//           currentIndex: _currentIndex,
//           onTap: _goToTab,
//         ),
//       ),
//     );
//   }
// }
import 'dart:ui' as ui;

import 'package:dental_app/core/notifications/device_token_sync.dart';
import 'package:dental_app/core/widgets/custom_confirmation_dialog.dart';
import 'package:dental_app/features/appointments/presentation/pages/my_appointments_page.dart';
import 'package:dental_app/features/home/presentation/pages/home_page.dart';
import 'package:dental_app/features/home/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:dental_app/features/profile/presentation/pages/profile_page.dart';
import 'package:dental_app/features/promotional_gallery/presentation/pages/promotional_gallery_page.dart';
import 'package:dental_app/features/treatment_plans/presentation/pages/treatment_plans_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  static void goToHomeTab() {
    _MainNavigationPageState._instance?._goToTab(homeTabIndex);
  }

  /// Bump refresh tokens so IndexedStack tabs reload remote data.
  static void notifyDataChanged() {
    _MainNavigationPageState._instance?._bumpRefreshTokens();
  }

  static Widget homeTabBackButton(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    return IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      icon: Icon(
        isRtl ? Icons.arrow_forward : Icons.arrow_back,
        color: colors.primary,
      ),
      onPressed: goToHomeTab,
    );
  }

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage>
    with WidgetsBindingObserver {
  static _MainNavigationPageState? _instance;

  int _currentIndex = AppBottomNavBar.emphasizedIndex;
  int _homeVisitCount = 0;
  int _appointmentsRefreshToken = 0;
  int _appointmentsUpcomingToken = 0;

  /// بيزيد أول ما تفتح الشاشة وكل ما التطبيق يرجع resume — بيفعّل
  /// فحص الـ pending rating بكارد الرئيسية.
  int _ratingCheckTick = 1;

  @override
  void initState() {
    super.initState();
    _instance = this;
    WidgetsBinding.instance.addObserver(this);
    // Register FCM with backend for this authenticated session.
    DeviceTokenSync.registerCurrentToken();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_instance == this) _instance = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!mounted) return;
      setState(() => _ratingCheckTick++);
    }
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
      _appointmentsUpcomingToken++;
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

  Future<void> _onSystemBack() async {
    if (_currentIndex != MainNavigationPage.homeTabIndex) {
      _goToTab(MainNavigationPage.homeTabIndex);
      return;
    }

    CustomConfirmationDialog.show(
      context,
      title: 'Exit the app'.tr(),
      description: 'Do you want to exit the app?'.tr(),
      confirmButtonText: 'Yes'.tr(),
      cancelButtonText: 'No'.tr(),
      isDestructive: true,
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        Navigator.of(context).pop();
        SystemNavigator.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _onSystemBack();
      },
      child: Scaffold(
        backgroundColor: colors.surfaceContainerHighest,
        extendBody: true,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            const ProfilePage(),
            MyAppointmentsPage(
              refreshToken: _appointmentsRefreshToken,
              upcomingTabToken: _appointmentsUpcomingToken,
            ),
            HomePage(
              homeVisitCount: _homeVisitCount,
              ratingCheckTick: _ratingCheckTick,
              isHomeTabActive: _currentIndex == MainNavigationPage.homeTabIndex,
            ),
            const TreatmentPlansPage(),
            const PromotionalGalleryPage(),
          ],
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _goToTab,
        ),
      ),
    );
  }
}
