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

typedef AdaptiveThemeBuilder = Widget Function(ThemeData light, ThemeData dark);

class AdaptiveTheme extends StatefulWidget {
  final ThemeData light;
  final ThemeData dark;
  final AdaptiveThemeMode initial;
  final AdaptiveThemeBuilder builder;

  static const String prefKey = 'adaptive_theme_preferences';

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

  static AdaptiveThemeState of(BuildContext context) =>
      context.findAncestorStateOfType<State<AdaptiveTheme>>();
}

class AdaptiveThemeState extends State<AdaptiveTheme> {
  ThemeData _theme;
  ThemeData _darkTheme;
  ThemeData _defaultTheme;
  ThemeData _defaultDarkTheme;
  ThemePreferences preferences;

  AdaptiveThemeState._(this._defaultTheme, this._defaultDarkTheme, AdaptiveThemeMode mode) {
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

  ThemeData get theme => preferences.mode.isDark ? _darkTheme : _theme;

  ThemeData get darkTheme => preferences.mode.isLight ? _theme : _darkTheme;

  AdaptiveThemeMode get mode => preferences.mode;

  bool get isDefault =>
      _theme == _defaultTheme &&
          _darkTheme == _defaultDarkTheme &&
          preferences.mode == preferences.defaultMode;

  Brightness get brightness => Theme.of(context).brightness;

  void setLight() => setThemeMode(AdaptiveThemeMode.light);

  void setDark() => setThemeMode(AdaptiveThemeMode.dark);

  void setSystem() => setThemeMode(AdaptiveThemeMode.system);

  void setThemeMode(AdaptiveThemeMode mode) {
    setState(() {
      preferences.mode = mode;
    });
    preferences.save();
  }

  void setTheme({@required ThemeData light, ThemeData dark, bool isDefault = false}) {
    assert(light != null);
    setState(() {
      _theme = light;
      _darkTheme = dark ?? light;
    });
    if (isDefault) {
      _defaultTheme = light.copyWith();
      _defaultDarkTheme = dark.copyWith();
    }
  }

  void toggleThemeMode() {
    mode.isLight ? setDark() : setLight();
  }

  Future<bool> persist() async => preferences.save();

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
