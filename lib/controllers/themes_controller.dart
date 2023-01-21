import 'package:firebase_test/models/theme.dart';
import 'package:firebase_test/providers/isar_service.dart';
import 'package:flutter/material.dart';

class ThemeController {
  static Future<ThemeMode> loadTheme() async {
    var theme = await isar.themeModels.get(1);
    if (theme?.theme == "dark") {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  static Future<void> saveTheme(ThemeMode mode) async {
    ThemeModel theme = ThemeModel()
      ..theme = modeToString[mode]!
      ..id = 1;

    await isar.writeTxn(
      () async => await isar.themeModels.put(theme),
    );
  }
}

Map<ThemeMode, String> modeToString = {
  ThemeMode.dark: "dark",
  ThemeMode.light: "light",
};
