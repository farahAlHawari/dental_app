import 'package:bloc/bloc.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
import 'package:meta/meta.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {

  ThemeBloc() : super(const ThemeState(ThemeMode.light)) {

    on<ToggleTheme>((event, emit) {

      if(state.themeMode == ThemeMode.light){

        emit(const ThemeState(ThemeMode.dark));

      }else{

        emit(const ThemeState(ThemeMode.light));

      }

    });

  }

}