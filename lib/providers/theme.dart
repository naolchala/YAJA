// ignore_for_file: non_constant_identifier_names

import 'package:firebase_test/compontents/week_picker.dart';
import 'package:firebase_test/controllers/themes_controller.dart';
import 'package:firebase_test/providers/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_test/models/theme.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark) {
    init();
  }

  void init() async {
    state = await ThemeController.loadTheme();
  }

  void toggleTheme() async {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await ThemeController.saveTheme(state);
  }
}

final ThemeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

// ignore:  prefer_function_declarations_over_variables
final GeneralTheme = ({Brightness? brightness}) => ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.rubikTextTheme(
        ThemeData(
          brightness: brightness ?? Brightness.light,
        ).textTheme,
      ),
      colorScheme: ThemeData(brightness: brightness ?? Brightness.light)
          .colorScheme
          .copyWith(
            primary: kPrimary,
            secondary: kSecondaryAccent,
          ),
    );

final lightTheme = GeneralTheme(brightness: Brightness.light);
final darkTheme = GeneralTheme(brightness: Brightness.dark);
