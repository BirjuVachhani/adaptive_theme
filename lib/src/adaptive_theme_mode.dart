// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

/// Represents the mode of the theme.
enum AdaptiveThemeMode {
  light('Light'),
  dark('Dark'),
  system('System');

  const AdaptiveThemeMode(this.modeName);

  final String modeName;

  bool get isLight => this == AdaptiveThemeMode.light;

  bool get isDark => this == AdaptiveThemeMode.dark;

  bool get isSystem => this == AdaptiveThemeMode.system;

  AdaptiveThemeMode next() {
    final nextIndex = (index + 1) % AdaptiveThemeMode.values.length;
    return AdaptiveThemeMode.values[nextIndex];
  }

  AdaptiveThemeMode previous() {
    final previousIndex = (index - 1) % AdaptiveThemeMode.values.length;
    return AdaptiveThemeMode.values[previousIndex];
  }
}
