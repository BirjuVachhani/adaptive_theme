/*
 * // Copyright © 2020 Birju Vachhani. All rights reserved.
 * // Use of this source code is governed by an Apache license that can be
 * // found in the LICENSE file.
 */

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('theme mode tests', () {
    expect(AdaptiveThemeMode.light.isLight, isTrue);
    expect(AdaptiveThemeMode.dark.isDark, isTrue);
    expect(AdaptiveThemeMode.system.isSystem, isTrue);
  });

  test('theme mode next tests', () {
    expect(AdaptiveThemeMode.light.next(), AdaptiveThemeMode.dark);
    expect(AdaptiveThemeMode.dark.next(), AdaptiveThemeMode.system);
    expect(AdaptiveThemeMode.system.next(), AdaptiveThemeMode.light);
  });

  test('theme mode previous tests', () {
    expect(AdaptiveThemeMode.light.previous(), AdaptiveThemeMode.system);
    expect(AdaptiveThemeMode.dark.previous(), AdaptiveThemeMode.light);
    expect(AdaptiveThemeMode.system.previous(), AdaptiveThemeMode.dark);
  });
}
