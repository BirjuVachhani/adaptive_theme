/*
 * Copyright © 2020 Birju Vachhani
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adaptive_theme.dart';
import 'adaptive_theme_mode.dart';

/// Utility for storing theme info in SharedPreferences
class ThemePreferences {
  late AdaptiveThemeMode mode;
  late AdaptiveThemeMode defaultMode;

  ThemePreferences.initial({this.mode = AdaptiveThemeMode.light})
      : defaultMode = mode;

  void reset() => mode = defaultMode;

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
      if (!kReleaseMode) {
        // ignore: avoid_print
        print(error);
        // ignore: avoid_print
        print(stacktrace);
      }
      return null;
    }
  }
}
