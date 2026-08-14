// Copyright © 2022 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

/// Builder function to build themed widgets
typedef FluentAdaptiveThemeBuilder =
    Widget Function(FluentThemeData light, FluentThemeData dark);

/// Widget that allows to switch themes dynamically. This is intended to be
/// used above [FluentApp].
/// Example:
///
/// FluentAdaptiveTheme(
///   light: lightTheme,
///   dark: darkTheme,
///   initial: AdaptiveThemeMode.light,
///   builder: (theme, darkTheme) => FluentApp(
///     theme: theme,
///     darkTheme: darkTheme,
///     home: MyHomePage(key: ValueKey(theme)),
///   ),
/// );
class FluentAdaptiveTheme extends StatefulWidget {
  /// Represents the light theme for the app.
  final FluentThemeData light;

  /// Represents the dark theme for the app.
  final FluentThemeData dark;

  /// Indicates which [AdaptiveThemeMode] to use initially.
  final AdaptiveThemeMode initial;

  /// Allows to ignore the persisted or [initial] theme mode and use this
  /// mode instead always. This is useful when you want to always start with
  /// a specific theme mode regardless of the persisted theme mode.
  /// Note that this will override the persisted theme mode as well.
  final AdaptiveThemeMode? overrideMode;

  /// Provides a builder with access of light and dark theme. Intended to
  /// be used to return [FluentApp].
  final FluentAdaptiveThemeBuilder builder;

  /// Indicates whether to show floating theme mode switcher button or not.
  /// This is ignored in release mode.
  final bool debugShowFloatingThemeButton;

  /// Key used to store theme information into shared-preferences. If you want
  /// to persist theme mode changes even after shared-preferences
  /// is cleared (e.g. after log out), do not remove this [prefKey] key from
  /// shared-preferences.
  static const String prefKey = 'adaptive_theme_preferences';

  /// Primary constructor which allows to configure themes initially.
  const FluentAdaptiveTheme({
    super.key,
    required this.light,
    FluentThemeData? dark,
    required this.initial,
    this.overrideMode,
    required this.builder,
    this.debugShowFloatingThemeButton = false,
  }) : dark = dark ?? light;

  @override
  State<FluentAdaptiveTheme> createState() => _FluentAdaptiveThemeState();

  /// Returns reference of the [AdaptiveThemeManager] which allows access of
  /// the state object of [FluentAdaptiveTheme] in a restrictive way.
  static AdaptiveThemeManager<FluentThemeData> of(BuildContext context) {
    context
        .dependOnInheritedWidgetOfExactType<
          InheritedAdaptiveTheme<FluentThemeData>
        >();
    return context.findAncestorStateOfType<State<FluentAdaptiveTheme>>()!
        as AdaptiveThemeManager<FluentThemeData>;
  }

  /// Returns reference of the [AdaptiveThemeManager] which allows access of
  /// the state object of [FluentAdaptiveTheme] in a restrictive way.
  /// This returns null if the state instance of [FluentAdaptiveTheme] is
  /// not found.
  static AdaptiveThemeManager<FluentThemeData>? maybeOf(BuildContext context) {
    context
        .dependOnInheritedWidgetOfExactType<
          InheritedAdaptiveTheme<FluentThemeData>
        >();
    final state = context.findAncestorStateOfType<State<FluentAdaptiveTheme>>();
    if (state == null) return null;
    return state as AdaptiveThemeManager<FluentThemeData>;
  }

  /// returns most recent theme mode. This can be used to eagerly get previous
  /// theme mode inside main method before calling [runApp].
  static Future<AdaptiveThemeMode?> getThemeMode() =>
      AdaptiveTheme.getThemeMode();
}

class _FluentAdaptiveThemeState extends State<FluentAdaptiveTheme>
    with WidgetsBindingObserver, AdaptiveThemeManager<FluentThemeData> {
  late bool _debugShowFloatingThemeButton = widget.debugShowFloatingThemeButton;

  @override
  bool get debugShowFloatingThemeButton => _debugShowFloatingThemeButton;

  @override
  void initState() {
    super.initState();
    initialize(
      light: widget.light,
      dark: widget.dark,
      initial: widget.initial,
      overrideMode: widget.overrideMode,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  /// When device theme mode is changed, Flutter does not rebuild
  /// app sometimes and Because of that, if theme is set to
  /// [AdaptiveThemeMode.system], it doesn't take effect.
  /// This check mitigates that and refreshes the UI to use new theme if needed.
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (mode.isSystem && mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant FluentAdaptiveTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.debugShowFloatingThemeButton !=
            oldWidget.debugShowFloatingThemeButton &&
        _debugShowFloatingThemeButton != widget.debugShowFloatingThemeButton) {
      _debugShowFloatingThemeButton = widget.debugShowFloatingThemeButton;
    }
  }

  @override
  bool get isDefault =>
      theme == widget.light && darkTheme == widget.dark && mode == defaultMode;

  @override
  Brightness get brightness => theme.brightness;

  @override
  Future<void> reset() async {
    setTheme(light: widget.light, dark: widget.dark, notify: false);
    return super.reset();
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.builder(theme, mode.isLight ? theme : darkTheme);

    return InheritedAdaptiveTheme<FluentThemeData>(
      manager: this,
      child: Builder(
        builder: (context) {
          if (!kReleaseMode && _debugShowFloatingThemeButton) {
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

  @override
  void setDebugShowFloatingThemeButton(bool enabled) {
    _debugShowFloatingThemeButton = enabled;
    setState(() {});
  }
}
