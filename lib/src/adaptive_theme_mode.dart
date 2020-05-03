enum AdaptiveThemeMode { light, dark, system }

extension AdaptiveThemeModeExtensions on AdaptiveThemeMode {
  bool get isLight => this == AdaptiveThemeMode.light;

  bool get isDark => this == AdaptiveThemeMode.dark;

  bool get isSystem => this == AdaptiveThemeMode.system;

  String get name {
    switch (this) {
      case AdaptiveThemeMode.light:
        return 'Light';
      case AdaptiveThemeMode.dark:
        return 'Dark';
      default:
        return 'System';
    }
  }
}
