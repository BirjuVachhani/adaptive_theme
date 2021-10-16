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

/// Represents the mode of the theme.
enum AdaptiveThemeMode { light, dark, system }

/// Provides accessibility methods for theme modes.
extension AdaptiveThemeModeExtensions on AdaptiveThemeMode {
  bool get isLight => this == AdaptiveThemeMode.light;

  bool get isDark => this == AdaptiveThemeMode.dark;

  bool get isSystem => this == AdaptiveThemeMode.system;

  /// String representation of [AdaptiveThemeMode]
  String get name {
    switch (this) {
      case AdaptiveThemeMode.light:
        return 'Light';
      case AdaptiveThemeMode.dark:
        return 'Dark';
      default:
        return 'System';
    }
  }
}
