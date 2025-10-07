// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adaptive_theme.dart';
import 'adaptive_theme_mode.dart';

/// Utility for storing theme info in SharedPreferences
class ThemePreferences {
  /// Represents the current theme mode.
  late AdaptiveThemeMode mode;

  /// Represents the default theme mode.
  late AdaptiveThemeMode defaultMode;

  ThemePreferences._(this.mode, this.defaultMode);

  /// Creates a new instance of ThemePreferences with the given [mode].
  ThemePreferences.initial({AdaptiveThemeMode mode = AdaptiveThemeMode.light})
      : this._(mode, mode);

  /// Resets the saved preferences to the default values.
  void reset() => mode = defaultMode;

  /// Creates a new instance of ThemePreferences from the given [json] data.
  ThemePreferences.fromJson(Map<String, dynamic> json) {
    if (json['theme_mode'] != null) {
      mode = AdaptiveThemeMode.values[json['theme_mode']];
    } else {
      mode = AdaptiveThemeMode.light;
    }
    if (json['default_theme_mode'] != null) {
      defaultMode = AdaptiveThemeMode.values[json['default_theme_mode']];
    } else {
      defaultMode = mode;
    }
  }

  /// Converts the current instance to a json object.
  Map<String, dynamic> toJson() =>
      {'theme_mode': mode.index, 'default_theme_mode': defaultMode.index};

  /// saves the current theme preferences to the shared-preferences
  Future<void> save() {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    return prefs.setString(AdaptiveTheme.prefKey, json.encode(toJson()));
  }

  /// retrieves preferences from the shared-preferences
  static Future<ThemePreferences?> fromPrefs() async {
    try {
      final SharedPreferencesAsync prefs = SharedPreferencesAsync();
      final themeDataString = await prefs.getString(AdaptiveTheme.prefKey);
      if (themeDataString == null || themeDataString.isEmpty) return null;
      return ThemePreferences.fromJson(json.decode(themeDataString));
    } on Exception catch (error, stacktrace) {
      if (kDebugMode) {
        print(error);
        print(stacktrace);
      }
      return null;
    }
  }
}
