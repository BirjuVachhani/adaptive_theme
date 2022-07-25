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
  late AdaptiveThemeMode mode;
  late AdaptiveThemeMode defaultMode;

  ThemePreferences._(this.mode, this.defaultMode);

  ThemePreferences.initial({AdaptiveThemeMode mode = AdaptiveThemeMode.light})
      : this._(mode, mode);

  void reset() => mode = defaultMode;

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

  Map<String, dynamic> toJson() => {
        'theme_mode': mode.index,
        'default_theme_mode': defaultMode.index,
      };

  /// saves the current theme preferences to the shared-preferences
  Future<bool> save() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(AdaptiveTheme.prefKey, json.encode(toJson()));
  }

  /// retrieves preferences from the shared-preferences
  static Future<ThemePreferences?> fromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeDataString = prefs.getString(AdaptiveTheme.prefKey);
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
