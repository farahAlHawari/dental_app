import 'package:bloc/bloc.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({ThemeMode initialMode = ThemeMode.light})
      : super(ThemeState(initialMode)) {
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final next = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await SharedPrefs.saveThemeMode(next);
    emit(ThemeState(next));
  }
}
