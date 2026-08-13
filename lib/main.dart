// import 'package:dental_app/core/theme/app_theme.dart';
import 'package:dental_app/core/navigation/app_bootstrap_page.dart';
import 'package:dental_app/core/theme/app_theme.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final savedLang = await SharedPrefs.getLanguage();
  final startLocale = savedLang == 'en'
      ? const Locale('en')
      : const Locale('ar');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      startLocale: startLocale,
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeBloc(),
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
                  textTheme: Theme.of(
                    context,
                  ).textTheme.apply(fontFamily: isArabic ? 'cr' : 'ir'),
                ),
                child: child!,
              );
            },
            home: const AppBootstrapPage(),
          );
        },
      ),
    );
  }
}
