// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

import 'package:adaptive_theme/src/debug_floating_theme_buttons.dart';
import 'package:adaptive_theme/src/inherited_adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

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

  /// Allows to ignore the persisted or [initial] theme mode and use this
  /// mode instead always. This is useful when you want to always start with
  /// a specific theme mode regardless of the persisted theme mode.
  /// Note that this will override the persisted theme mode as well.
  final AdaptiveThemeMode? overrideMode;

  /// Provides a builder with access of light and dark theme. Intended to
  /// be used to return [CupertinoApp].
  final CupertinoAdaptiveThemeBuilder builder;

  /// Indicates whether to show floating theme mode switcher button or not.
  /// This is ignored in release mode.
  final bool debugShowFloatingThemeButton;

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
    this.overrideMode,
    this.debugShowFloatingThemeButton = false,
  }) : dark = dark ?? light;

  @override
  State<CupertinoAdaptiveTheme> createState() => _CupertinoAdaptiveThemeState();

  /// Returns reference of the [CupertinoAdaptiveThemeManager] which allows access of
  /// the state object of [CupertinoAdaptiveTheme] in a restrictive way.
  static AdaptiveThemeManager<CupertinoThemeData> of(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<
        InheritedAdaptiveTheme<CupertinoThemeData>>()!;
    return context.findAncestorStateOfType<State<CupertinoAdaptiveTheme>>()!
        as AdaptiveThemeManager<CupertinoThemeData>;
  }

  /// Returns reference of the [CupertinoAdaptiveThemeManager] which allows access of
  /// the state object of [CupertinoAdaptiveTheme] in a restrictive way.
  /// This returns null if the state instance of [CupertinoAdaptiveTheme] is not found.
  static AdaptiveThemeManager<CupertinoThemeData>? maybeOf(
      BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<
        InheritedAdaptiveTheme<CupertinoThemeData>>();
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
  /// [CupertinoApp] and Because of that, if theme is set to
  /// [AdaptiveThemeMode.system]. it doesn't take effect. This check mitigates
  /// that and refreshes the UI to use new theme if needed.
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (mode.isSystem && mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant CupertinoAdaptiveTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.debugShowFloatingThemeButton !=
            oldWidget.debugShowFloatingThemeButton &&
        _debugShowFloatingThemeButton != widget.debugShowFloatingThemeButton) {
      _debugShowFloatingThemeButton = widget.debugShowFloatingThemeButton;
    }
    if (widget.overrideMode != oldWidget.overrideMode) {
      if (widget.overrideMode != null) {
        setThemeMode(widget.overrideMode!);
      }
    }
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
    return InheritedAdaptiveTheme<CupertinoThemeData>(
      manager: this,
      child: Builder(
        builder: (context) {
          final Widget child;
          // This ensures that when device theme mode is changed, this also reacts
          // to it and applies required changes.
          if (mode.isSystem) {
            final brightness =
                View.of(context).platformDispatcher.platformBrightness;
            child = widget
                .builder(brightness == Brightness.light ? theme : darkTheme);
          } else {
            child = widget.builder(mode.isLight ? theme : darkTheme);
          }

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
  void setDebugShowFloatingThemeButton(bool enabled) {
    _debugShowFloatingThemeButton = enabled;
    setState(() {});
  }

  @override
  void dispose() {
    modeChangeNotifier.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
