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
import 'package:flutter/scheduler.dart';

import 'adaptive_theme_mode.dart';
import 'adaptive_theme_preferences.dart';
import 'cupertino_adaptive_theme_manager.dart';

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
  })  : dark = dark ?? light,
        super(key: key);

  @override
  _CupertinoAdaptiveThemeState createState() => _CupertinoAdaptiveThemeState();

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
    if (state == null || state is! CupertinoAdaptiveThemeManager) return null;
    return state as CupertinoAdaptiveThemeManager;
  }

  /// returns most recent theme mode. This can be used to eagerly get previous
  /// theme mode inside main method before calling [runApp].
  static Future<AdaptiveThemeMode?> getThemeMode() async {
    return (await ThemePreferences.fromPrefs())?.mode;
  }
}

class _CupertinoAdaptiveThemeState extends State<CupertinoAdaptiveTheme>
    with WidgetsBindingObserver
    implements CupertinoAdaptiveThemeManager {
  late CupertinoThemeData _theme;
  late CupertinoThemeData _darkTheme;
  late ThemePreferences _preferences;
  late ValueNotifier<AdaptiveThemeMode> _modeChangeNotifier;

  @override
  void initState() {
    super.initState();

    _theme = widget.light;
    _modeChangeNotifier = ValueNotifier(widget.initial);
    _darkTheme = widget.dark;
    _preferences = ThemePreferences.initial(mode: widget.initial);
    ThemePreferences.fromPrefs().then((pref) {
      if (pref == null) {
        _preferences.save();
      } else {
        _preferences = pref;
        if (mounted) {
          setState(() {});
        }
      }
    });
    WidgetsBinding.instance?.addObserver(this);
  }

  /// When device theme mode is changed, Flutter does not rebuild
  /// [CupertinoApp] and Because of that, if theme is set to
  /// [AdaptiveThemeMode.system]. it doesn't take effect. This check mitigates
  /// that and refreshes the UI to use new theme if needed.
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (mode.isSystem && mounted) {
      setState(() {});
    }
  }

  @override
  ValueNotifier<AdaptiveThemeMode> get modeChangeNotifier =>
      _modeChangeNotifier;

  @override
  CupertinoThemeData get theme {
    // This ensures that when device theme mode is changed, this also reacts
    // to it and applies required changes.
    if (_preferences.mode.isSystem) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return brightness == Brightness.light ? _theme : _darkTheme;
    }
    return _preferences.mode.isDark ? _darkTheme : _theme;
  }

  @override
  CupertinoThemeData get lightTheme => _theme;

  @override
  CupertinoThemeData get darkTheme => _darkTheme;

  @override
  AdaptiveThemeMode get mode => _preferences.mode;

  @override
  bool get isDefault =>
      _theme == widget.light &&
      _darkTheme == widget.dark &&
      _preferences.mode == _preferences.defaultMode;

  @override
  Brightness? get brightness => theme.brightness;

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
    _preferences.save();
  }

  @override
  void setTheme({
    required CupertinoThemeData light,
    CupertinoThemeData? dark,
    bool notify = true,
  }) {
    _theme = light;
    if (dark != null) {
      _darkTheme = dark;
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
  Future<bool> persist() async => _preferences.save();

  @override
  Future<bool> reset() async {
    _preferences.reset();
    _theme = widget.light;
    _darkTheme = widget.dark;
    if (mounted) {
      setState(() {});
    }
    modeChangeNotifier.value = mode;
    return _preferences.save();
  }

  @override
  Widget build(BuildContext context) {
    // This ensures that when device theme mode is changed, this also reacts
    // to it and applies required changes.
    if (_preferences.mode.isSystem) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return widget
          .builder(brightness == Brightness.light ? _theme : _darkTheme);
    }
    return widget.builder(_preferences.mode.isLight ? _theme : _darkTheme);
  }

  @override
  void dispose() {
    _modeChangeNotifier.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
