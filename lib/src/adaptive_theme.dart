// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

import 'package:adaptive_theme/src/debug_floating_theme_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'adaptive_theme_manager.dart';
import 'adaptive_theme_mode.dart';
import 'adaptive_theme_preferences.dart';
import 'inherited_adaptive_theme.dart';

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

  /// Indicates whether to show floating theme mode switcher button or not.
  /// This is ignored in release mode.
  final bool debugShowFloatingThemeButton;

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
    this.debugShowFloatingThemeButton = false,
  }) : dark = dark ?? light;

  @override
  State<AdaptiveTheme> createState() => _AdaptiveThemeState();

  /// Returns reference of the [AdaptiveThemeManager] which allows access of
  /// the state object of [AdaptiveTheme] in a restrictive way.
  static AdaptiveThemeManager<ThemeData> of(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<
        InheritedAdaptiveTheme<ThemeData>>()!;
    return context.findAncestorStateOfType<State<AdaptiveTheme>>()!
        as AdaptiveThemeManager<ThemeData>;
  }

  /// Returns reference of the [AdaptiveThemeManager] which allows access of
  /// the state object of [AdaptiveTheme] in a restrictive way.
  /// This returns null if the state instance of [AdaptiveTheme] is not found.
  static AdaptiveThemeManager<ThemeData>? maybeOf(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<
        InheritedAdaptiveTheme<ThemeData>>();
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
  Widget build(BuildContext context) {
    final child = widget.builder(theme, mode.isLight ? theme : darkTheme);

    return InheritedAdaptiveTheme<ThemeData>(
      manager: this,
      child: Builder(
        builder: (context) {
          if (!kReleaseMode && widget.debugShowFloatingThemeButton) {
            return DebugFloatingThemeButtonWrapper(
              manager: this,
              debugShow: true,
              child: child,
            );
          }

          return child;
        },
      ),
    );
  }

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
