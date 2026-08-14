// import 'package:dental_app/core/theme/app_theme.dart';
import 'package:dental_app/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
import 'package:dental_app/core/navigation/app_bootstrap_page.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/splash/presentation/pages/splash_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();



  final savedLang = await SharedPrefs.getLanguage();
  final startLocale =
      savedLang == 'en' ? const Locale('en') : const Locale('ar');
  final savedTheme = await SharedPrefs.getThemeMode();
  final hasSeenSplash = await SharedPrefs.hasSeenSplash();

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    startLocale: startLocale,
    path: 'assets/translations',
    fallbackLocale: const Locale('ar'),
    child: MyApp(
      initialTheme: savedTheme,
      hasSeenSplash: hasSeenSplash,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.initialTheme,
    required this.hasSeenSplash,
  });

  final ThemeMode initialTheme;
  final bool hasSeenSplash;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeBloc(initialMode: initialTheme),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.themeMode,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              final isArabic = context.locale.languageCode == 'ar';

              return Theme(
                data: Theme.of(context).copyWith(
                  textTheme: Theme.of(context).textTheme.apply(
                        fontFamily: "cr",
                      ),
                ),
                child: child!,
              );
            },
            home: hasSeenSplash
                ? const AppBootstrapPage()
                : const SplashPage(),
          );
        },
      ),
    );
  }
}
