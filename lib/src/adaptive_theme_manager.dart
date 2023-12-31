// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

import 'package:adaptive_theme/src/adaptive_theme_preferences.dart';
import 'package:flutter/material.dart';

import 'adaptive_theme_mode.dart';

/// Entry point to change/modify theme or access theme related information
/// from [AdaptiveTheme].
/// An instance of this can be retrieved by calling [AdaptiveTheme.of].
mixin AdaptiveThemeManager<T extends Object> {
  late T _theme;
  late T _darkTheme;

  late ThemePreferences _preferences;

  late ValueNotifier<AdaptiveThemeMode> _modeChangeNotifier;

  /// provides current theme
  T get theme {
    if (_preferences.mode.isSystem) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.light ? _theme : _darkTheme;
    }
    return _preferences.mode.isDark ? _darkTheme : _theme;
  }

  /// provides the light theme
  T get lightTheme => _theme;

  /// provides the dark theme
  T get darkTheme => _darkTheme;

  /// Returns current theme mode
  AdaptiveThemeMode get mode => _preferences.mode;

  /// Returns the default(initial) theme mode
  AdaptiveThemeMode get defaultMode => _preferences.defaultMode;

  /// Allows to listen to changes in them mode.
  ValueNotifier<AdaptiveThemeMode> get modeChangeNotifier =>
      _modeChangeNotifier;

  /// checks whether current theme is default theme or not. Default theme
  /// refers to he themes provided at the time of initialization
  /// of [MaterialApp].
  bool get isDefault;

  /// provides brightness of the current theme
  Brightness? get brightness;

  /// Whether to show floating theme mode switcher button or not.
  bool get debugShowFloatingThemeButton;

  void initialize({
    required T light,
    required T dark,
    required AdaptiveThemeMode initial,
  }) {
    _theme = light;
    _modeChangeNotifier = ValueNotifier(initial);
    _darkTheme = dark;
    _preferences = ThemePreferences.initial(mode: initial);

    ThemePreferences.fromPrefs().then((pref) {
      if (pref == null) {
        _preferences.save();
      } else {
        _preferences = pref;
        updateState();
      }
    });
  }

  /// Sets light theme as current
  /// Uses [AdaptiveThemeMode.light].
  void setLight() => setThemeMode(AdaptiveThemeMode.light);

  /// Sets dark theme as current
  /// Uses [AdaptiveThemeMode.dark].
  void setDark() => setThemeMode(AdaptiveThemeMode.dark);

  /// Sets theme based on the theme of the underlying OS.
  /// Uses [AdaptiveThemeMode.system].
  void setSystem() => setThemeMode(AdaptiveThemeMode.system);

  /// Allows to set/change theme mode.
  void setThemeMode(AdaptiveThemeMode mode) {
    _preferences.mode = mode;
    updateState();
    _modeChangeNotifier.value = mode;
    _preferences.save();
  }

  /// Allows to set/change the entire theme.
  /// [notify] when set to true, will update the UI to use the new theme..
  void setTheme({
    required T light,
    T? dark,
    bool notify = true,
  }) {
    _theme = light;
    if (dark != null) _darkTheme = dark;
    if (notify) updateState();
  }

  /// Allows to toggle between theme modes [AdaptiveThemeMode.light],
  /// [AdaptiveThemeMode.dark] and [AdaptiveThemeMode.system].
  void toggleThemeMode({bool useSystem = true}) {
    AdaptiveThemeMode nextMode = mode.next();
    if (!useSystem && nextMode.isSystem) {
      // Skip system mode.
      nextMode = nextMode.next();
    }
    setThemeMode(nextMode);
  }

  /// Saves the configuration to the shared-preferences. This can be useful
  /// when you want to persist theme settings after clearing
  /// shared-preferences. e.g. when user logs out, usually, preferences
  /// are cleared. Call this method after clearing preferences to
  /// persist theme mode.
  Future<bool> persist() async => _preferences.save();

  /// Resets configuration to default configuration which has been provided
  /// while initializing [MaterialApp].
  /// If [setTheme] method has been called with [isDefault] to true, Calling
  /// this method afterwards will use theme provided by [setTheme] as default
  /// themes.
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.reset()`.
  @mustCallSuper
  Future<bool> reset() async {
    _preferences.reset();
    updateState();
    modeChangeNotifier.value = mode;
    return _preferences.save();
  }

  void updateState();

  /// Sets whether to show floating theme mode switcher button or not.
  void setDebugShowFloatingThemeButton(bool enabled);
}
