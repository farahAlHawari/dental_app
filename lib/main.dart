import 'package:dental_app/core/theme/app_theme.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
import 'package:dental_app/features/login/presentation/pages/login_page.dart';
import 'package:dental_app/features/change_language/presentation/pages/choose_language.dart';
import 'package:dental_app/features/onboarding/presentation/pages/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //    theme: AppTheme.light,

    //   darkTheme: AppTheme.dark,

    //   themeMode: state.themeMode,
    //    debugShowCheckedModeBanner: false,
    //   home: ChooseLanguage() ,
    // );
  return  BlocProvider(

 create: (_) => ThemeBloc(),

 child: BlocBuilder<ThemeBloc,ThemeState>(

 builder: (context,state){

   return MaterialApp(

      theme: AppTheme.light,

      darkTheme: AppTheme.dark,

      themeMode: state.themeMode,
          debugShowCheckedModeBanner: false,
      home: ChooseLanguage() ,

   );

 },

),

);
  }
}
