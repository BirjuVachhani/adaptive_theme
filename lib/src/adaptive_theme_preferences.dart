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

part of adaptive_theme;

class ThemePreferences {
  late AdaptiveThemeMode mode;
  late AdaptiveThemeMode defaultMode;

  ThemePreferences._initial({this.mode = AdaptiveThemeMode.light}) {
    defaultMode = mode;
  }

  void _reset() {
    mode = defaultMode;
  }

  ThemePreferences._fromJson(Map<String, dynamic> json) {
    if (json['theme_mode'] != null) {
      mode = AdaptiveThemeMode.values[json['theme_mode']];
    }
    if (json['default_theme_mode'] != null) {
      defaultMode = AdaptiveThemeMode.values[json['default_theme_mode']];
    } else {
      defaultMode = mode;
    }
  }

  Map<String, dynamic> _toJson() {
    final data = <String, dynamic>{};
    data['theme_mode'] = mode.index;
    data['default_theme_mode'] = defaultMode.index;
    return data;
  }

  /// saves the current theme preferences to the shared-preferences
  Future<bool> _save() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(AdaptiveTheme.prefKey, json.encode(_toJson()));
  }

  /// retrieves preferences from the shared-preferences
  static Future<ThemePreferences?> _fromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeDataString = prefs.getString(AdaptiveTheme.prefKey);
      if (themeDataString == null || themeDataString.isEmpty) return null;
      return ThemePreferences._fromJson(json.decode(themeDataString));
    } on Exception catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      return null;
    }
  }
}
