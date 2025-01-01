// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

/// Represents the mode of the theme.
enum AdaptiveThemeMode {
  /// Represents the light mode of the theme.
  light('Light'),

  /// Represents the dark mode of the theme.
  dark('Dark'),

  /// Represents the system mode of the theme.
  system('System');

  const AdaptiveThemeMode(this.modeName);

  /// A formatted string representing the mode.
  final String modeName;

  /// Whether the mode is light mode.
  bool get isLight => this == AdaptiveThemeMode.light;

  /// Whether the mode is dark mode.
  bool get isDark => this == AdaptiveThemeMode.dark;

  /// Whether the mode is system mode.
  bool get isSystem => this == AdaptiveThemeMode.system;

  /// Loops through the mode values in a cyclic manner and returns the next mode
  /// in the sequence.
  AdaptiveThemeMode next() {
    final int nextIndex = (index + 1) % AdaptiveThemeMode.values.length;
    return AdaptiveThemeMode.values[nextIndex];
  }

  /// Loops through the mode values in a cyclic manner and returns the previous
  /// mode in the sequence.
  AdaptiveThemeMode previous() {
    final int previousIndex = (index - 1) % AdaptiveThemeMode.values.length;
    return AdaptiveThemeMode.values[previousIndex];
  }
}
