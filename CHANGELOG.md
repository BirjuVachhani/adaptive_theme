# 3.7.2

- Migrate Shared Preferences usage to new Async API.
- Add `AdaptiveTheme.read(context)` method to read current theme without creating a dependency on it.

# 3.7.1+2

- Re-generate `example/web` directory with latest Flutter version.
- Bump up `shared_preferences` dependency's minimum constraints to `2.5.0`.
- Fix imports for `Brightness`.

# 3.7.1+1

- Fix imports.

# 3.7.1

- Code cleanup.
- Remove deprecated class name usage from docs.

# 3.7.0

- [BREAKING] Remove deprecated `CupertinoAdaptiveThemeManager`. Use `AdaptiveThemeManager<CupertinoThemeData>` instead.
- [BREAKING] Require Flutter `3.27.0` or higher: Replace deprecated use of `withOpacity` with `withValues`.
- Add `overrideMode` parameter to `AdaptiveTheme` and `CupertinoAdaptiveTheme` to override theme mode manually.
- Fix unnecessary material imports.
- Update missing docs for source code.

# 3.6.0

- Migrate `DebugFloatingThemeButton` to Material 3.
- Expose `DebugFloatingThemeButton` as a public widget for extensions to work with it.

# 3.5.0

- Add support for dynamically changing `debugShowFloatingThemeButton` state using
  `AdaptiveTheme.of(context).setDebugShowFloatingThemeButton(bool)` method.
- Allow reading state of `debugShowFloatingThemeButton` using `AdaptiveTheme.of(context).debugShowFloatingThemeButton`.

# 3.4.1

- Fix readme example code.
- Update example app for a simpler example code.
- Update example to use Material 3.

# 3.4.0

- FEAT: Add` useSystem` flag for `toggleThemeMode` method to toggle between light, dark only when the flag is set to
  false.
- Add more tests.

# 3.3.1

- Add pub topics to package metadata.
- Upgrade dependencies.

# 3.3.0

- Upgrade SDK constraints to Dart 3.0 and Flutter 3.10.0.
- Refactor deprecated api usages to new ones.
- Use `WidgetsBinding.instance.platformDispatcher` instead of `PlatformDispatcher.instance` since its recommended.

# 3.2.1

- Fix missing inherited widget for CupertinoAdaptiveTheme.

# 3.2.0

- Fix calling `AdaptiveTheme.of` or `CupertinoAdaptiveTheme.of` not creating a dependency on it.
- Add screenshots for pub.dev.

# 3.1.1

- Add `fix_data.yaml` for Flutter fix feature for deprecation quick fix suggestion.
- Remove redundant code.
- Update copyright headers.

# 3.1.0

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

- Fixed [#18](https://github.com/BirjuVachhani/adaptive_theme/issues/18)
- Dark theme not working properly on all
  platforms.

# 2.1.0

- Fixed [#16](https://github.com/BirjuVachhani/adaptive_theme/issues/16) - get theme and get darkTheme returns the same
  theme depended on mode
- Added [#15](https://github.com/BirjuVachhani/adaptive_theme/issues/15) - Notify listener when changing theme mode

# 2.0.0

- Improved documentation
- Stable null safety support
- Calling `AdaptiveTheme.of(context).toggleThemeMode()` now will sequentially loop through `AdaptiveThemeMode.light`
  , `AdaptiveThemeMode.dark` and `AdaptiveThemeMode.system` instead of just `AdaptiveThemeMode.light`
  and `AdaptiveThemeMode.dark`.

# 2.0.0-nullsafety.1

- Migrate to null safety.

# 1.1.0

- Removed hard coded `shared_preferences` version.
- Hide public constructors for `ThemePreferences`.
- `AdaptiveTheme.of()` now returns instance of `AdaptiveThemeManager` instead of `AdaptiveThemeState` to set
  restrictions for accessing state directly.

# 1.0.0

- Add option to get previous theme mode on app startup.

# 0.1.1

- Add option to silently update theme without notifying. Useful when chaining multiple changes.

# 0.1.0

- Supports theme modes: light, dart, system default.
- Persists theme modes across app restarts.
- Allows to toggle theme mode between light and dark.
- Allows to set default theme.
- Allows to reset to default theme.
