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

abstract class AdaptiveThemeManager {
  /// provides current the light theme
  ThemeData get theme;

  /// provides the dart theme
  ThemeData get darkTheme;

  /// returns current theme mode
  AdaptiveThemeMode get mode;

  /// checks whether current theme is default theme or not. Default theme refers
  /// the themes provided while initialization
  bool get isDefault;

  /// provides brightness of the current theme
  Brightness get brightness;

  /// sets light theme as current
  void setLight();

  /// sets dark theme as current
  void setDark();

  /// sets theme based on the theme of the device
  void setSystem();

  /// allows to set/change theme mode
  void setThemeMode(AdaptiveThemeMode mode);

  /// allows to set/change the entire theme.
  void setTheme({
    @required ThemeData light,
    ThemeData dark,
    bool isDefault = false,
    bool notify = true,
  });

  /// Allows to toggle between theme modes
  void toggleThemeMode();

  /// saves the configuration to the shared-preferences
  Future<bool> persist();

  /// resets configuration to default
  Future<bool> reset();
}
