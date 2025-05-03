import 'package:flutter/material.dart';
import 'package:moneymate/theme/theme_localstorage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(ThemeLocalStorage themeLocalStorage) : super(ThemeMode.light);

  void toggleTheme() {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }

  init() {}

}