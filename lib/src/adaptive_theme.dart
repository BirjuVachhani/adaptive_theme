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

  AdaptiveThemeState._(
      this._defaultTheme, this._defaultDarkTheme, AdaptiveThemeMode mode) {
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

  void setTheme(
      {@required ThemeData light, ThemeData dark, bool isDefault = false}) {
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
