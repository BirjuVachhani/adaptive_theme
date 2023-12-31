/*
 * // Copyright © 2020 Birju Vachhani. All rights reserved.
 * // Use of this source code is governed by an Apache license that can be
 * // found in the LICENSE file.
 */

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adaptive_theme/src/debug_floating_theme_buttons.dart';
import 'package:flutter/cupertino.dart';
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

  testWidgets('setDebugShowFloatingThemeButton test', (tester) async {
    final light = ThemeData.light();
    final dark = ThemeData.dark();
    await pumpMaterialApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
      debugShowFloatingThemeButton: true,
    );

    DebugFloatingThemeButton widget = tester.widget<DebugFloatingThemeButton>(
        find.byType(DebugFloatingThemeButton));
    expect(widget.debugShow, isTrue);

    BuildContext context = tester.element(find.byType(Scaffold));
    AdaptiveThemeManager<ThemeData> manager = AdaptiveTheme.of(context);

    expect(manager.debugShowFloatingThemeButton, isTrue);
    manager.setDebugShowFloatingThemeButton(false);

    await tester.pumpAndSettle();

    expect(find.byType(DebugFloatingThemeButton), findsNothing);
    expect(manager.debugShowFloatingThemeButton, isFalse);
  });

  testWidgets('setDebugShowFloatingThemeButton test with didUpdateWidget',
      (tester) async {
    final light = ThemeData.light();
    final dark = ThemeData.dark();
    ValueNotifier<bool> debugShowFloatingThemeButton = ValueNotifier(true);

    await tester.pumpWidget(
      ValueListenableBuilder<bool>(
        valueListenable: debugShowFloatingThemeButton,
        builder: (context, value, child) {
          return AdaptiveTheme(
            light: light,
            dark: dark,
            initial: AdaptiveThemeMode.light,
            debugShowFloatingThemeButton: value,
            builder: (light, dark) => MaterialApp(
              theme: light,
              darkTheme: dark,
              home: Scaffold(
                appBar: AppBar(
                  title: const Text('AdaptiveTheme Test'),
                ),
                body: const Center(
                  child: Text('Hello'),
                ),
              ),
            ),
          );
        },
      ),
    );

    DebugFloatingThemeButton widget = tester.widget<DebugFloatingThemeButton>(
        find.byType(DebugFloatingThemeButton));
    expect(widget.debugShow, isTrue);

    BuildContext context = tester.element(find.byType(Scaffold));
    AdaptiveThemeManager<ThemeData> manager = AdaptiveTheme.of(context);

    expect(manager.debugShowFloatingThemeButton, isTrue);

    debugShowFloatingThemeButton.value = false;

    await tester.pumpAndSettle();

    expect(find.byType(DebugFloatingThemeButton), findsNothing);

    context = tester.element(find.byType(Scaffold));
    manager = AdaptiveTheme.of(context);
    expect(manager.debugShowFloatingThemeButton, isFalse);
  });

  testWidgets('setDebugShowFloatingThemeButton for cupertino test',
      (tester) async {
    const light = CupertinoThemeData(brightness: Brightness.light);
    const dark = CupertinoThemeData(brightness: Brightness.dark);
    await pumpCupertinoApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
      debugShowFloatingThemeButton: true,
    );

    DebugFloatingThemeButton widget = tester.widget<DebugFloatingThemeButton>(
        find.byType(DebugFloatingThemeButton));
    expect(widget.debugShow, isTrue);

    BuildContext context = tester.element(find.byType(CupertinoPageScaffold));
    AdaptiveThemeManager<CupertinoThemeData> manager =
        CupertinoAdaptiveTheme.of(context);

    expect(manager.debugShowFloatingThemeButton, isTrue);
    manager.setDebugShowFloatingThemeButton(false);

    await tester.pumpAndSettle();

    expect(find.byType(DebugFloatingThemeButton), findsNothing);
    expect(manager.debugShowFloatingThemeButton, isFalse);
  });

  testWidgets(
      'setDebugShowFloatingThemeButton test for cupertino with didUpdateWidget',
      (tester) async {
    const light = CupertinoThemeData(brightness: Brightness.light);
    const dark = CupertinoThemeData(brightness: Brightness.dark);
    ValueNotifier<bool> debugShowFloatingThemeButton = ValueNotifier(true);

    await tester.pumpWidget(
      ValueListenableBuilder<bool>(
        valueListenable: debugShowFloatingThemeButton,
        builder: (context, value, child) {
          return CupertinoAdaptiveTheme(
            light: light,
            dark: dark,
            initial: AdaptiveThemeMode.light,
            debugShowFloatingThemeButton: value,
            builder: (theme) => CupertinoApp(
              theme: theme,
              home: const CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text('Cupertino Example'),
                ),
                child: Center(
                  child: Text('Hello'),
                ),
              ),
            ),
          );
        },
      ),
    );

    DebugFloatingThemeButton widget = tester.widget<DebugFloatingThemeButton>(
        find.byType(DebugFloatingThemeButton));
    expect(widget.debugShow, isTrue);

    BuildContext context = tester.element(find.byType(CupertinoPageScaffold));
    AdaptiveThemeManager<CupertinoThemeData> manager =
        CupertinoAdaptiveTheme.of(context);

    expect(manager.debugShowFloatingThemeButton, isTrue);

    debugShowFloatingThemeButton.value = false;

    await tester.pumpAndSettle();

    expect(find.byType(DebugFloatingThemeButton), findsNothing);

    context = tester.element(find.byType(CupertinoPageScaffold));
    manager = CupertinoAdaptiveTheme.of(context);
    expect(manager.debugShowFloatingThemeButton, isFalse);
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
