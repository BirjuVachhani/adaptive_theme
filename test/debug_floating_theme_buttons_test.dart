/*
 * // Copyright © 2020 Birju Vachhani. All rights reserved.
 * // Use of this source code is governed by an Apache license that can be
 * // found in the LICENSE file.
 */

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adaptive_theme/src/debug_floating_theme_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  testWidgets('debugShowFloatingThemeButton test', (tester) async {
    final light = ThemeData.light();
    final dark = ThemeData.dark();
    await pumpMaterialApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
      debugShowFloatingThemeButton: true,
    );

    final widget = tester.widget<DebugFloatingThemeButton>(
        find.byType(DebugFloatingThemeButton));
    expect(widget.debugShow, isTrue);
  });

  testWidgets('DebugFloatingThemeButton show/hide test', (tester) async {
    final light = ThemeData.light();
    final dark = ThemeData.dark();
    await pumpMaterialApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
      debugShowFloatingThemeButton: true,
    );

    final BuildContext context = tester.element(find.byType(Scaffold));
    final manager = AdaptiveTheme.of(context);

    final widgetFinder = find.byType(DebugFloatingThemeButton);
    final dragIndicatorFinder = find.descendant(
        of: widgetFinder, matching: find.byIcon(Icons.drag_indicator_rounded));

    final widget = tester.widget<DebugFloatingThemeButton>(widgetFinder);
    expect(widget.debugShow, isTrue);

    final rect = tester.getRect(dragIndicatorFinder);
    await tester.tapAt(rect.center);
    await tester.pumpAndSettle();

    final toggleButtonFinder =
        find.descendant(of: widgetFinder, matching: find.byType(ToggleButtons));
    ToggleButtons buttonsWidget() =>
        tester.widget<ToggleButtons>(toggleButtonFinder);

    // check if light theme is selected
    expect(
        buttonsWidget().isSelected, containsAllInOrder([true, false, false]));

    // select dark theme
    buttonsWidget().onPressed?.call(1);
    await tester.pumpAndSettle();

    expect(manager.mode, AdaptiveThemeMode.dark);
    expect(
        buttonsWidget().isSelected, containsAllInOrder([false, true, false]));

    // select system theme
    buttonsWidget().onPressed?.call(2);
    await tester.pumpAndSettle();

    expect(manager.mode, AdaptiveThemeMode.system);
    expect(
        buttonsWidget().isSelected, containsAllInOrder([false, false, true]));
  });
}
