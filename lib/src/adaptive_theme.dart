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

import 'adaptive_theme_manager.dart';
import 'adaptive_theme_mode.dart';
import 'adaptive_theme_preferences.dart';

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
    super.key,
    required this.light,
    ThemeData? dark,
    required this.initial,
    required this.builder,
  }) : dark = dark ?? light;

  @override
  State<AdaptiveTheme> createState() => _AdaptiveThemeState();

  /// Returns reference of the [AdaptiveThemeManager] which allows access of
  /// the state object of [AdaptiveTheme] in a restrictive way.
  static AdaptiveThemeManager<ThemeData> of(BuildContext context) =>
      context.findAncestorStateOfType<State<AdaptiveTheme>>()!
          as AdaptiveThemeManager<ThemeData>;

  /// Returns reference of the [AdaptiveThemeManager] which allows access of
  /// the state object of [AdaptiveTheme] in a restrictive way.
  /// This returns null if the state instance of [AdaptiveTheme] is not found.
  static AdaptiveThemeManager<ThemeData>? maybeOf(BuildContext context) {
    final state = context.findAncestorStateOfType<State<AdaptiveTheme>>();
    if (state == null) return null;
    return state as AdaptiveThemeManager<ThemeData>;
  }

  /// returns most recent theme mode. This can be used to eagerly get previous
  /// theme mode inside main method before calling [runApp].
  static Future<AdaptiveThemeMode?> getThemeMode() async {
    return (await ThemePreferences.fromPrefs())?.mode;
  }
}

class _AdaptiveThemeState extends State<AdaptiveTheme>
    with WidgetsBindingObserver, AdaptiveThemeManager<ThemeData> {
  @override
  void initState() {
    super.initState();
    initialize(
      light: widget.light,
      dark: widget.dark,
      initial: widget.initial,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  // When device theme mode is changed, Flutter does not rebuild
  /// [CupertinoApp] and Because of that, if theme is set to
  /// [AdaptiveThemeMode.system]. it doesn't take effect. This check mitigates
  /// that and refreshes the UI to use new theme if needed.
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (mode.isSystem && mounted) setState(() {});
  }

  @override
  bool get isDefault =>
      lightTheme == widget.light &&
      darkTheme == widget.dark &&
      mode == defaultMode;

  @override
  Brightness get brightness => theme.brightness;

  @override
  Future<bool> reset() async {
    setTheme(
      light: widget.light,
      dark: widget.dark,
      notify: false,
    );
    return super.reset();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(theme, mode.isLight ? theme : darkTheme);

  @override
  void updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    modeChangeNotifier.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
