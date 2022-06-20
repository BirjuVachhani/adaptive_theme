# 3.1.0 (Unreleased)

- `CupertinoAdaptiveThemeManager` is now deprecated and replaced with `AdaptiveThemeManager<CupertinoThemeData>` in
  favor of supporting theming for other UI frameworks. (e.g. Fluent UI). This will be removed in `v4.0.0`.
- `AdaptiveThemeManager` is now generic typed where the generic type represents the type of the theme data object.
  Replace `AdaptiveThemeManager` with `AdaptiveThemeManager<ThemeData>`
- `AdaptiveThemeManager` is now a **mixin** instead of **an abstract class** to reduce code duplication.

# 3.0.0

- Upgrade to Flutter 3.
- Update & fix tests.
- Update AdaptiveThemeMode enum.
- Fix lints warnings & refactor code.

# 2.3.1

- Fixed Material theme not updating on system theme change.
- Updated example android project.

# 2.3.0

- Fixed Cupertino theme not changing when on system mode.
- Internal code cleanup.
- Removed `isDefault` option from `setTheme` method. Default are meant to come from `AdaptiveTheme` widget itself.
- Added flutter lints.
- Fixed doc comments and typos.
- Added `reset` and custom theme options in the example app.
- Fixed `AdaptiveTheme`'s `brightness` and `theme` getters.
- Fixed `CupertinoAdaptiveTheme`'s `brightness` and `theme` getters.
- Added Tests.

# 2.2.0

- Added support for Cupertino theme.

# 2.1.1

- Fixed [#18](https://github.com/BirjuVachhani/adaptive_theme/issues/18) - Dark theme not working properly on all
  platforms.

## 2.1.0

- Fixed [#16](https://github.com/BirjuVachhani/adaptive_theme/issues/16) - get theme and get darkTheme returns the same
  theme depended on mode
- Added [#15](https://github.com/BirjuVachhani/adaptive_theme/issues/15) - Notify listener when changing theme mode

## 2.0.0

- Improved documentation
- Stable null safety support
- Calling `AdaptiveTheme.of(context).toggleThemeMode()` now will sequentially loop through `AdaptiveThemeMode.light`
  , `AdaptiveThemeMode.dark` and `AdaptiveThemeMode.system` instead of just `AdaptiveThemeMode.light`
  and `AdaptiveThemeMode.dark`.

## 2.0.0-nullsafety.1

- migrate to null safety

## 1.1.0

- Removed hard coded `shared_preferences` version.
- Hide public constructors for `ThemePreferences`.
- `AdaptiveTheme.of()` now returns instance of `AdaptiveThemeManager` instead of `AdaptiveThemeState` to set
  restrictions for accessing state directly.

## 1.0.0

- add option to get previous theme mode on app startup

## 0.1.1

- add option to silently update theme without notifying. Useful when chaining multiple changes.

## 0.1.0

- Supports theme modes: light, dart, system default.
- Persists theme modes across app restarts.
- Allows to toggle theme mode between light and dark.
- Allows to set default theme.
- Allows to reset to default theme.
