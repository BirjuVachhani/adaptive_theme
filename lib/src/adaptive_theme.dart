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
    Key? key,
    required this.light,
    ThemeData? dark,
    required this.initial,
    required this.builder,
  })   : this.dark = dark ?? light,
        super(key: key);

  @override
  _AdaptiveThemeState createState() =>
      _AdaptiveThemeState._(light, dark, initial);

  /// returns state of the [AdaptiveTheme]
  static AdaptiveThemeManager of(BuildContext context) =>
      context.findAncestorStateOfType<State<AdaptiveTheme>>()!
          as AdaptiveThemeManager;

  /// returns state of the [AdaptiveTheme] or returns null if not found
  static AdaptiveThemeManager? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<State<AdaptiveTheme>>()
          as AdaptiveThemeManager?;

  /// returns most recent theme mode
  static Future<AdaptiveThemeMode?> getThemeMode() async {
    return (await ThemePreferences._fromPrefs())?.mode;
  }
}

class _AdaptiveThemeState extends State<AdaptiveTheme>
    implements AdaptiveThemeManager {
  late ThemeData _theme;
  late ThemeData _darkTheme;
  late ThemeData _defaultTheme;
  late ThemeData _defaultDarkTheme;
  late ThemePreferences preferences;

  _AdaptiveThemeState._(
      this._defaultTheme, this._defaultDarkTheme, AdaptiveThemeMode mode) {
    _theme = _defaultTheme.copyWith();
    _darkTheme = _defaultDarkTheme.copyWith();
    preferences = ThemePreferences._initial(mode: mode);
    ThemePreferences._fromPrefs().then((pref) {
      if (pref == null) {
        preferences._save();
      } else {
        preferences = pref;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  ThemeData get theme => preferences.mode.isDark ? _darkTheme : _theme;

  @override
  ThemeData get darkTheme => preferences.mode.isLight ? _theme : _darkTheme;

  @override
  AdaptiveThemeMode get mode => preferences.mode;

  @override
  bool get isDefault =>
      _theme == _defaultTheme &&
      _darkTheme == _defaultDarkTheme &&
      preferences.mode == preferences.defaultMode;

  @override
  Brightness get brightness => Theme.of(context).brightness;

  @override
  void setLight() => setThemeMode(AdaptiveThemeMode.light);

  @override
  void setDark() => setThemeMode(AdaptiveThemeMode.dark);

  @override
  void setSystem() => setThemeMode(AdaptiveThemeMode.system);

  @override
  void setThemeMode(AdaptiveThemeMode mode) {
    setState(() {
      preferences.mode = mode;
    });
    preferences._save();
  }

  @override
  void setTheme({
    required ThemeData light,
    ThemeData? dark,
    bool isDefault = false,
    bool notify = true,
  }) {
    _theme = light;
    if (dark != null) {
      _darkTheme = dark;
    }
    if (isDefault) {
      _defaultTheme = light.copyWith();
      _defaultDarkTheme = _darkTheme.copyWith();
    }
    if (notify) {
      setState(() {});
    }
  }

  @override
  void toggleThemeMode() {
    mode.isLight ? setDark() : setLight();
  }

  @override
  Future<bool> persist() async => preferences._save();

  @override
  Future<bool> reset() async {
    preferences._reset();
    _theme = _defaultTheme.copyWith();
    _darkTheme = _defaultDarkTheme.copyWith();
    if (mounted) {
      setState(() {});
    }
    return preferences._save();
  }

  @override
  Widget build(BuildContext context) => widget.builder(theme, darkTheme);
}
