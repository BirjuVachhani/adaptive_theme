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

/// Builder function to build themed widgets
typedef AdaptiveThemeBuilder = Widget Function(ThemeData light, ThemeData dark);

/// Widget that allows to switch themes dynamically. This is intended to be
/// used above [MaterialApp].
/// Example:
///
/// AdaptiveTheme(
///   light: lightTheme,
///   dark: darkTheme,
///   initial: AdaptiveThemeMode.light,
///   builder: (theme, darkTheme) => MaterialApp(
///     theme: theme,
///     darkTheme: darkTheme,
///     home: MyHomePage(),
///   ),
/// );
class AdaptiveTheme extends StatefulWidget {
  /// Represents the light theme for the app.
  final ThemeData light;

  /// Represents the dark theme for the app.
  final ThemeData dark;

  /// Indicates which [AdaptiveThemeMode] to use initially.
  final AdaptiveThemeMode initial;

  /// Provides a builder with access of light and dark theme. Intended to
  /// be used to return [MaterialApp].
  final AdaptiveThemeBuilder builder;

  /// Key used to store theme information into shared-preferences. If you want
  /// to persist theme mode changes even after shared-preferences
  /// is cleared (e.g. after log out), do not remove this [prefKey] key from
  /// shared-preferences.
  static const String prefKey = 'adaptive_theme_preferences';

  /// Primary constructor which allows to configure themes initially.
  const AdaptiveTheme({
    Key? key,
    required this.light,
    ThemeData? dark,
    required this.initial,
    required this.builder,
  })  : this.dark = dark ?? light,
        super(key: key);

  @override
  _AdaptiveThemeState createState() =>
      _AdaptiveThemeState._(light, dark, initial);

  /// Returns reference of the [AdaptiveThemeManager] which allows access of
  /// the state object of [AdaptiveTheme] in a restrictive way.
  static AdaptiveThemeManager of(BuildContext context) =>
      context.findAncestorStateOfType<State<AdaptiveTheme>>()!
          as AdaptiveThemeManager;

  /// Returns reference of the [AdaptiveThemeManager] which allows access of
  /// the state object of [AdaptiveTheme] in a restrictive way.
  /// This returns null if the state instance of [AdaptiveTheme] is not found.
  static AdaptiveThemeManager? maybeOf(BuildContext context) {
    final state = context.findAncestorStateOfType<State<AdaptiveTheme>>();
    if (state == null) return null;
    return state as AdaptiveThemeManager;
  }

  /// returns most recent theme mode. This can be used to eagerly get previous
  /// theme mode inside main method before calling [runApp].
  static Future<AdaptiveThemeMode?> getThemeMode() async {
    return (await _ThemePreferences._fromPrefs())?.mode;
  }
}

class _AdaptiveThemeState extends State<AdaptiveTheme>
    implements AdaptiveThemeManager {
  late ThemeData _theme;
  late ThemeData _darkTheme;
  late ThemeData _defaultTheme;
  late ThemeData _defaultDarkTheme;
  late _ThemePreferences _preferences;
  late ValueNotifier<AdaptiveThemeMode> _modeChangeNotifier;

  _AdaptiveThemeState._(
      this._defaultTheme, this._defaultDarkTheme, AdaptiveThemeMode mode) {
    _theme = _defaultTheme.copyWith();
    _modeChangeNotifier = ValueNotifier(mode);
    _darkTheme = _defaultDarkTheme.copyWith();
    _preferences = _ThemePreferences._initial(mode: mode);
    _ThemePreferences._fromPrefs().then((pref) {
      if (pref == null) {
        _preferences._save();
      } else {
        _preferences = pref;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  ValueNotifier<AdaptiveThemeMode> get modeChangeNotifier =>
      _modeChangeNotifier;

  @override
  ThemeData get theme => _preferences.mode.isDark ? _darkTheme : _theme;

  @override
  ThemeData get lightTheme => _theme;

  @override
  ThemeData get darkTheme => _darkTheme;

  @override
  AdaptiveThemeMode get mode => _preferences.mode;

  @override
  bool get isDefault =>
      _theme == _defaultTheme &&
      _darkTheme == _defaultDarkTheme &&
      _preferences.mode == _preferences.defaultMode;

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
    _preferences.mode = mode;
    if (mounted) {
      setState(() {});
    }
    _modeChangeNotifier.value = mode;
    _preferences._save();
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
    if (notify && mounted) {
      setState(() {});
    }
  }

  @override
  void toggleThemeMode() {
    final nextModeIndex = (mode.index + 1) % AdaptiveThemeMode.values.length;
    final nextMode = AdaptiveThemeMode.values[nextModeIndex];
    setThemeMode(nextMode);
  }

  @override
  Future<bool> persist() async => _preferences._save();

  @override
  Future<bool> reset() async {
    _preferences._reset();
    _theme = _defaultTheme.copyWith();
    _darkTheme = _defaultDarkTheme.copyWith();
    if (mounted) {
      setState(() {});
    }
    modeChangeNotifier.value = mode;
    return _preferences._save();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(theme, _preferences.mode.isLight ? _theme : _darkTheme);

  @override
  void dispose() {
    _modeChangeNotifier.dispose();
    super.dispose();
  }
}
