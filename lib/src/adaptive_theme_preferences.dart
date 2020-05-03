import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'adaptive_theme.dart';
import 'adaptive_theme_mode.dart';

class ThemePreferences {
  AdaptiveThemeMode mode;
  AdaptiveThemeMode defaultMode;

  ThemePreferences({
    this.mode = AdaptiveThemeMode.light,
  });

  ThemePreferences.initial({
    this.mode = AdaptiveThemeMode.light,
  }) {
    defaultMode = mode;
  }

  void reset() {
    mode = defaultMode;
  }

  ThemePreferences.fromJson(Map<String, dynamic> json) {
    if (json['theme_mode'] != null) {
      mode = AdaptiveThemeMode.values[json['theme_mode']];
    }
    if (json['default_theme_mode'] != null) {
      defaultMode = AdaptiveThemeMode.values[json['default_theme_mode']];
    } else {
      defaultMode = mode;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['theme_mode'] = mode.index;
    data['default_theme_mode'] = defaultMode.index;
    return data;
  }

  /// saves the current theme preferences to the shared-preferences
  Future<bool> save() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(AdaptiveTheme.prefKey, json.encode(toJson()));
  }

  /// retrieves preferences from the shared-preferences
  static Future<ThemePreferences> fromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeDataString = prefs.getString(AdaptiveTheme.prefKey);
      if (themeDataString?.isEmpty ?? true) return null;
      return ThemePreferences.fromJson(json.decode(themeDataString));
    } on Exception catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      return null;
    }
  }
}
