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

import 'package:flutter/cupertino.dart';

import 'adaptive_theme_mode.dart';

/// Entry point to change/modify theme or access theme related information
/// from [CupertinoAdaptiveTheme].
/// An instance of this can be retrieved by calling [CupertinoAdaptiveTheme.of].
abstract class CupertinoAdaptiveThemeManager {
  /// provides current theme
  CupertinoThemeData get theme;

  /// provides the light theme
  CupertinoThemeData get lightTheme;

  /// provides the dark theme
  CupertinoThemeData get darkTheme;

  /// Returns current theme mode
  AdaptiveThemeMode get mode;

  /// Allows to listen to changes in them mode.
  ValueNotifier<AdaptiveThemeMode> get modeChangeNotifier;

  /// checks whether current theme is default theme or not. Default theme
  /// refers to he themes provided at the time of initialization
  /// of [CupertinoApp].
  bool get isDefault;

  /// provides brightness of the current theme
  Brightness? get brightness;

  /// Sets light theme as current
  /// Uses [AdaptiveThemeMode.light].
  void setLight();

  /// Sets dark theme as current
  /// Uses [AdaptiveThemeMode.dark].
  void setDark();

  /// Sets theme based on the theme of the underlying OS.
  /// Uses [AdaptiveThemeMode.system].
  void setSystem();

  /// Allows to set/change theme mode.
  void setThemeMode(AdaptiveThemeMode mode);

  /// Allows to set/change the entire theme.
  /// [notify] when set to true, will update the UI to use the new theme.
  void setTheme({
    required CupertinoThemeData light,
    CupertinoThemeData? dark,
    bool notify = true,
  });

  /// Allows to toggle between theme modes [AdaptiveThemeMode.light],
  /// [AdaptiveThemeMode.dark] and [AdaptiveThemeMode.system].
  void toggleThemeMode();

  /// Saves the configuration to the shared-preferences. This can be useful
  /// when you want to persist theme settings after clearing
  /// shared-preferences. e.g. when user logs out, usually, preferences
  /// are cleared. Call this method after clearing preferences to
  /// persist theme mode.
  Future<bool> persist();

  /// Resets configuration to default configuration which has been provided
  /// while initializing [CupertinoApp].
  /// If [setTheme] method has been called with [isDefault] to true, Calling
  /// this method afterwards will use theme provided by [setTheme] as default
  /// themes.
  Future<bool> reset();
}
