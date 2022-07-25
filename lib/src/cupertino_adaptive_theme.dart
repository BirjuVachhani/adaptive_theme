// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

import 'adaptive_theme_manager.dart';
import 'adaptive_theme_mode.dart';
import 'adaptive_theme_preferences.dart';

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
    super.key,
    required this.light,
    CupertinoThemeData? dark,
    required this.initial,
    required this.builder,
  }) : dark = dark ?? light;

  @override
  State<CupertinoAdaptiveTheme> createState() => _CupertinoAdaptiveThemeState();

  /// Returns reference of the [CupertinoAdaptiveThemeManager] which allows access of
  /// the state object of [CupertinoAdaptiveTheme] in a restrictive way.
  static AdaptiveThemeManager<CupertinoThemeData> of(BuildContext context) =>
      context.findAncestorStateOfType<State<CupertinoAdaptiveTheme>>()!
          as AdaptiveThemeManager<CupertinoThemeData>;

  /// Returns reference of the [CupertinoAdaptiveThemeManager] which allows access of
  /// the state object of [CupertinoAdaptiveTheme] in a restrictive way.
  /// This returns null if the state instance of [CupertinoAdaptiveTheme] is not found.
  static AdaptiveThemeManager<CupertinoThemeData>? maybeOf(
      BuildContext context) {
    final state =
        context.findAncestorStateOfType<State<CupertinoAdaptiveTheme>>();
    if (state == null || state is! AdaptiveThemeManager<CupertinoThemeData>) {
      return null;
    }
    return state as AdaptiveThemeManager<CupertinoThemeData>;
  }

  /// returns most recent theme mode. This can be used to eagerly get previous
  /// theme mode inside main method before calling [runApp].
  static Future<AdaptiveThemeMode?> getThemeMode() async {
    return (await ThemePreferences.fromPrefs())?.mode;
  }
}

class _CupertinoAdaptiveThemeState extends State<CupertinoAdaptiveTheme>
    with WidgetsBindingObserver, AdaptiveThemeManager<CupertinoThemeData> {
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

  /// When device theme mode is changed, Flutter does not rebuild
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
      theme == widget.light && darkTheme == widget.dark && mode == defaultMode;

  @override
  Brightness? get brightness => theme.brightness;

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
    // This ensures that when device theme mode is changed, this also reacts
    // to it and applies required changes.
    if (mode.isSystem) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return widget.builder(brightness == Brightness.light ? theme : darkTheme);
    }
    return widget.builder(mode.isLight ? theme : darkTheme);
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
