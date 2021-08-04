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
typedef CupertinoAdaptiveThemeBuilder = Widget Function(
    CupertinoThemeData theme);

/// Widget that allows to switch themes dynamically. This is intended to be
/// used above [CupertinoApp].
/// Example:
///
/// CupertinoAdaptiveTheme(
///   light: lightTheme,
///   dark: darkTheme,
///   initial: AdaptiveThemeMode.light,
///   builder: (theme, darkTheme) => CupertinoApp(
///     theme: theme,
///     darkTheme: darkTheme,
///     home: MyHomePage(),
///   ),
/// );
class CupertinoAdaptiveTheme extends StatefulWidget {
  /// Represents the light theme for the app.
  final CupertinoThemeData light;

  /// Represents the dark theme for the app.
  final CupertinoThemeData dark;

  /// Indicates which [AdaptiveThemeMode] to use initially.
  final AdaptiveThemeMode initial;

  /// Provides a builder with access of light and dark theme. Intended to
  /// be used to return [CupertinoApp].
  final CupertinoAdaptiveThemeBuilder builder;

  /// Key used to store theme information into shared-preferences. If you want
  /// to persist theme mode changes even after shared-preferences
  /// is cleared (e.g. after log out), do not remove this [prefKey] key from
  /// shared-preferences.
  static const String prefKey = 'adaptive_theme_preferences';

  /// Primary constructor which allows to configure themes initially.
  const CupertinoAdaptiveTheme({
    Key? key,
    required this.light,
    CupertinoThemeData? dark,
    required this.initial,
    required this.builder,
  })  : this.dark = dark ?? light,
        super(key: key);

  @override
  _CupertinoAdaptiveThemeState createState() =>
      _CupertinoAdaptiveThemeState._(light, dark, initial);

  /// Returns reference of the [CupertinoAdaptiveThemeManager] which allows access of
  /// the state object of [CupertinoAdaptiveTheme] in a restrictive way.
  static CupertinoAdaptiveThemeManager of(BuildContext context) =>
      context.findAncestorStateOfType<State<CupertinoAdaptiveTheme>>()!
          as CupertinoAdaptiveThemeManager;

  /// Returns reference of the [CupertinoAdaptiveThemeManager] which allows access of
  /// the state object of [CupertinoAdaptiveTheme] in a restrictive way.
  /// This returns null if the state instance of [CupertinoAdaptiveTheme] is not found.
  static CupertinoAdaptiveThemeManager? maybeOf(BuildContext context) {
    final state =
        context.findAncestorStateOfType<State<CupertinoAdaptiveTheme>>();
    if (state == null) return null;
    return state as CupertinoAdaptiveThemeManager;
  }

  /// returns most recent theme mode. This can be used to eagerly get previous
  /// theme mode inside main method before calling [runApp].
  static Future<AdaptiveThemeMode?> getThemeMode() async {
    return (await _ThemePreferences._fromPrefs())?.mode;
  }
}

class _CupertinoAdaptiveThemeState extends State<CupertinoAdaptiveTheme>
    implements CupertinoAdaptiveThemeManager {
  late CupertinoThemeData _theme;
  late CupertinoThemeData _darkTheme;
  late CupertinoThemeData _defaultTheme;
  late CupertinoThemeData _defaultDarkTheme;
  late _ThemePreferences _preferences;
  late ValueNotifier<AdaptiveThemeMode> _modeChangeNotifier;

  _CupertinoAdaptiveThemeState._(
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
  CupertinoThemeData get theme =>
      _preferences.mode.isDark ? _darkTheme : _theme;

  @override
  CupertinoThemeData get lightTheme => _theme;

  @override
  CupertinoThemeData get darkTheme => _darkTheme;

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
    required CupertinoThemeData light,
    CupertinoThemeData? dark,
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
      widget.builder(_preferences.mode.isLight ? _theme : _darkTheme);

  @override
  void dispose() {
    _modeChangeNotifier.dispose();
    super.dispose();
  }
}
