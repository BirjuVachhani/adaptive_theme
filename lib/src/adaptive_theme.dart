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

import 'package:flutter/material.dart';

import 'adaptive_theme_mode.dart';
import 'adaptive_theme_preferences.dart';

/// builder function to build themed widgets
typedef AdaptiveThemeBuilder = Widget Function(ThemeData light, ThemeData dark);

/// Widget that allows to switch themes dynamically
class AdaptiveTheme extends StatefulWidget {
  final ThemeData light;
  final ThemeData dark;
  final AdaptiveThemeMode initial;
  final AdaptiveThemeBuilder builder;

  // Key used to store theme information into shared-preferences
  static const String prefKey = 'adaptive_theme_preferences';

  /// primary constructor
  const AdaptiveTheme({
    Key key,
    @required this.light,
    this.dark,
    @required this.initial,
    @required this.builder,
  }) : super(key: key);

  @override
  AdaptiveThemeState createState() =>
      AdaptiveThemeState._(light, dark ?? light, initial);

  /// returns state of the [AdaptiveTheme]
  static AdaptiveThemeState of(BuildContext context) =>
      context.findAncestorStateOfType<State<AdaptiveTheme>>();

  /// returns most recent theme mode
  static Future<AdaptiveThemeMode> getThemeMode() async {
    return (await ThemePreferences.fromPrefs())?.mode;
  }
}

class AdaptiveThemeState extends State<AdaptiveTheme> {
  ThemeData _theme;
  ThemeData _darkTheme;
  ThemeData _defaultTheme;
  ThemeData _defaultDarkTheme;
  ThemePreferences preferences;

  AdaptiveThemeState._(
      this._defaultTheme, this._defaultDarkTheme, AdaptiveThemeMode mode) {
    _theme = _defaultTheme.copyWith();
    _darkTheme = _defaultDarkTheme.copyWith();
    preferences = ThemePreferences.initial(mode: mode);
    ThemePreferences.fromPrefs().then((pref) {
      if (pref == null) {
        preferences.save();
      } else {
        preferences = pref;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  /// provides current the light theme
  ThemeData get theme => preferences.mode.isDark ? _darkTheme : _theme;

  /// provides the dart theme
  ThemeData get darkTheme => preferences.mode.isLight ? _theme : _darkTheme;

  /// returns current theme mode
  AdaptiveThemeMode get mode => preferences.mode;

  /// checks whether current theme is default theme or not. Default theme refers
  /// the themes provided while initialization
  bool get isDefault =>
      _theme == _defaultTheme &&
      _darkTheme == _defaultDarkTheme &&
      preferences.mode == preferences.defaultMode;

  /// provides brightness of the current theme
  Brightness get brightness => Theme.of(context).brightness;

  /// sets light theme as current
  void setLight() => setThemeMode(AdaptiveThemeMode.light);

  /// sets dark theme as current
  void setDark() => setThemeMode(AdaptiveThemeMode.dark);

  /// sets theme based on the theme of the device
  void setSystem() => setThemeMode(AdaptiveThemeMode.system);

  /// allows to set/change theme mode
  void setThemeMode(AdaptiveThemeMode mode) {
    setState(() {
      preferences.mode = mode;
    });
    preferences.save();
  }

  /// allows to set/change the entire theme.
  void setTheme({
    @required ThemeData light,
    ThemeData dark,
    bool isDefault = false,
    bool notify = true,
  }) {
    assert(light != null);
    _theme = light;
    _darkTheme = dark ?? light;
    if (isDefault) {
      _defaultTheme = light.copyWith();
      _defaultDarkTheme = dark.copyWith();
    }
    if (notify) {
      setState(() {});
    }
  }

  /// Allows to toggle between theme modes
  void toggleThemeMode() {
    mode.isLight ? setDark() : setLight();
  }

  /// saves the configuration to the shared-preferences
  Future<bool> persist() async => preferences.save();

  /// resets configuration to default
  Future<bool> reset() async {
    preferences.reset();
    _theme = _defaultTheme.copyWith();
    _darkTheme = _defaultDarkTheme.copyWith();
    if (mounted) {
      setState(() {});
    }
    return preferences.save();
  }

  @override
  Widget build(BuildContext context) => widget.builder(theme, darkTheme);
}
