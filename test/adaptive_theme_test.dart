// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adaptive_theme/src/adaptive_theme_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_utils.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('AdaptiveTheme initial light theme test', (tester) async {
    await pumpMaterialApp(
      tester,
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      mode: AdaptiveThemeMode.light,
    );

    final BuildContext context = tester.element(find.byType(Scaffold));

    expect(Theme.of(context).brightness, equals(Brightness.light),
        reason: 'initial theme was set to light but actual is different.');
  });

  testWidgets('AdaptiveTheme initial dark theme test', (tester) async {
    await pumpMaterialApp(
      tester,
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      mode: AdaptiveThemeMode.dark,
    );

    final BuildContext context = tester.element(find.byType(Scaffold));

    expect(Theme.of(context).brightness, equals(Brightness.dark),
        reason: 'initial theme was set to dark but actual is different.');
  });

  testWidgets('AdaptiveTheme load saved prefs test', (tester) async {
    final initialData = {
      'theme_mode': AdaptiveThemeMode.dark.index,
      'default_theme_mode': AdaptiveThemeMode.light.index,
    };
    SharedPreferences.setMockInitialValues({
      AdaptiveTheme.prefKey: json.encode(initialData),
    });

    await pumpMaterialApp(
      tester,
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      mode: AdaptiveThemeMode.light,
    );

    await tester.pumpAndSettle();

    final BuildContext context = tester.element(find.byType(Scaffold));

    expect(Theme.of(context).brightness, equals(Brightness.dark),
        reason: 'initial theme was set to dark but actual is different.');
    expect(AdaptiveTheme.of(context).mode.isDark, isTrue,
        reason: 'saved mode was dark but loaded mode is different.');
  });

  testWidgets('AdaptiveThemeManager retrieval tests', (tester) async {
    await pumpMaterialApp(
      tester,
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      mode: AdaptiveThemeMode.light,
    );

    BuildContext context = tester.element(find.byType(Scaffold));
    expect(AdaptiveTheme.of(context), isA<AdaptiveThemeManager>(),
        reason:
            'AdaptiveTheme.of should return instance of AdaptiveThemeManager but actually returned something else.');
    expect(AdaptiveTheme.maybeOf(context), isNotNull,
        reason: 'AdaptiveTheme.maybeOf should not return null but it did.');
    expect(AdaptiveTheme.maybeOf(context), isA<AdaptiveThemeManager>(),
        reason:
            'AdaptiveTheme.maybeOf should return instance of AdaptiveThemeManager but actually returned something else.');

    await tester.pumpWidget(Container());
    context = tester.element(find.byType(Container));

    expect(() => AdaptiveTheme.of(context), throwsA(anything),
        reason:
            'AdaptiveTheme.of should throw when not located in widget tree but it did not.');
    expect(AdaptiveTheme.maybeOf(context), isNull,
        reason:
            'AdaptiveTheme.maybeOf should be null and not throwing when not located in widget tree but it returned something else.');
  });

  testWidgets('AdaptiveTheme.getThemeMode() Tests', (tester) async {
    expect(AdaptiveTheme.getThemeMode(), completes);
    expect(AdaptiveTheme.getThemeMode(), completion(isNull));

    await pumpMaterialApp(
      tester,
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      mode: AdaptiveThemeMode.light,
    );

    expect(AdaptiveTheme.getThemeMode(), completes,
        reason: 'getThemeMode should complete without fail but it did not.');
    expect(AdaptiveTheme.getThemeMode(), completion(isNotNull),
        reason:
            'getThemeMode should return a non-null value but it returned null.');
    expect(AdaptiveTheme.getThemeMode(),
        completion(equals(AdaptiveThemeMode.light)),
        reason:
            'getThemeMode should return light mode but it returned something else.');
  });

  testWidgets('theme, lightTheme, darkTheme and mode Tests', (tester) async {
    final light = ThemeData.light();
    final dark = ThemeData.dark();
    await pumpMaterialApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    final BuildContext context = tester.element(find.byType(Scaffold));
    final manager = AdaptiveTheme.of(context);

    expect(manager.theme, equals(light),
        reason: 'manager.theme should be light but it is not.');
    expect(manager.lightTheme, equals(light),
        reason: 'manager.lightTheme should be light but it is not.');
    expect(manager.darkTheme, equals(dark),
        reason: 'manager.darkTheme should be dark but it is not.');
    expect(manager.mode, equals(AdaptiveThemeMode.light),
        reason: 'manager.mode should be light mode but it is not.');

    manager.setDark();
    await tester.pumpAndSettle();
    expect(manager.theme, equals(dark),
        reason:
            'manager.theme should be dark after setting dark theme but it is not.');
    expect(manager.mode, equals(AdaptiveThemeMode.dark),
        reason: 'manager.mode should be dark but it is not.');
  });

  testWidgets('toggleThemeMode Tests', (tester) async {
    final light = ThemeData.light();
    final dark = ThemeData.dark();
    await pumpMaterialApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    final BuildContext context = tester.element(find.byType(Scaffold));
    final manager = AdaptiveTheme.of(context);

    expect(manager.mode, equals(AdaptiveThemeMode.light),
        reason: 'manager.mode should be light mode but it is not.');
    expect(manager.mode.isLight, isTrue,
        reason: 'manager.mode should be light mode but it is not.');

    manager.toggleThemeMode();
    expect(manager.mode, equals(AdaptiveThemeMode.dark),
        reason: 'manager.mode should be dark mode but it is not.');
    expect(manager.mode.isDark, isTrue,
        reason: 'manager.mode should be dark mode but it is not.');

    manager.toggleThemeMode();
    expect(manager.mode, equals(AdaptiveThemeMode.system),
        reason: 'manager.mode should be system mode but it is not.');
    expect(manager.mode.isSystem, isTrue,
        reason: 'manager.mode should be system mode but it is not.');
  });

  testWidgets('toggleThemeMode without system Tests', (tester) async {
    final light = ThemeData.light();
    final dark = ThemeData.dark();
    await pumpMaterialApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    final BuildContext context = tester.element(find.byType(Scaffold));
    final manager = AdaptiveTheme.of(context);

    expect(manager.mode, equals(AdaptiveThemeMode.light),
        reason: 'manager.mode should be light mode but it is not.');
    expect(manager.mode.isLight, isTrue,
        reason: 'manager.mode should be light mode but it is not.');

    manager.toggleThemeMode(useSystem: false);
    expect(manager.mode, equals(AdaptiveThemeMode.dark),
        reason: 'manager.mode should be dark mode but it is not.');
    expect(manager.mode.isDark, isTrue,
        reason: 'manager.mode should be dark mode but it is not.');

    manager.toggleThemeMode(useSystem: false);
    expect(manager.mode, equals(AdaptiveThemeMode.light),
        reason: 'manager.mode should be light mode but it is not.');
    expect(manager.mode.isLight, isTrue,
        reason: 'manager.mode should be light mode but it is not.');
  });

  testWidgets('setThemeMode Tests', (tester) async {
    final light = ThemeData.light();
    final dark = ThemeData.dark();
    await pumpMaterialApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    final BuildContext context = tester.element(find.byType(Scaffold));
    final manager = AdaptiveTheme.of(context);

    expect(manager.mode, equals(AdaptiveThemeMode.light),
        reason: 'manager.mode should be light mode but it is not.');
    expect(Theme.of(context).brightness, equals(Brightness.light),
        reason: 'theme brightness should be light mode but it is not.');

    manager.setThemeMode(AdaptiveThemeMode.dark);
    await tester.pumpAndSettle();
    expect(manager.mode, equals(AdaptiveThemeMode.dark),
        reason: 'manager.mode should be dark mode but it is not.');
    expect(Theme.of(context).brightness, equals(Brightness.dark),
        reason: 'theme brightness should be dark mode but it is not.');

    manager.setThemeMode(AdaptiveThemeMode.system);
    await tester.pumpAndSettle();
    expect(manager.mode, equals(AdaptiveThemeMode.system),
        reason: 'manager.mode should be system mode but it is not.');

    manager.setLight();
    await tester.pumpAndSettle();
    expect(manager.mode.isLight, isTrue,
        reason: 'manager.mode should be light mode but it is not.');
    expect(Theme.of(context).brightness, equals(Brightness.light),
        reason: 'theme brightness should be light mode but it is not.');

    manager.setDark();
    await tester.pumpAndSettle();
    expect(manager.mode.isDark, isTrue,
        reason: 'manager.mode should be dark mode but it is not.');
    expect(Theme.of(context).brightness, equals(Brightness.dark),
        reason: 'theme brightness should be dark mode but it is not.');

    manager.setSystem();
    await tester.pumpAndSettle();
    expect(manager.mode.isSystem, isTrue,
        reason: 'manager.mode should be system mode but it is not.');
  });

  testWidgets('custom theme and reset Tests', (tester) async {
    final light = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
    );
    final dark = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
    );
    await pumpMaterialApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    final BuildContext context = tester.element(find.byType(Scaffold));
    final manager = AdaptiveTheme.of(context);

    manager.setTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.red,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.red,
        ));

    await tester.pumpAndSettle();
    expect(manager.isDefault, isFalse,
        reason:
            'after setting custom theme, manager.isDefault should not be true but it is.');
    expect(manager.lightTheme.brightness, equals(Brightness.light));
    expect(manager.darkTheme.brightness, equals(Brightness.dark));

    expect(manager.lightTheme.primaryColor, equals(Colors.red),
        reason:
            'manager.lightTheme should hold custom light theme but it does not.');
    expect(manager.darkTheme.primaryColor, equals(Colors.red),
        reason:
            'manager.lightTheme should hold custom dark theme but it does not.');

    expect(Theme.of(context).brightness, equals(Brightness.light),
        reason: 'theme brightness should be light mode but it is not.');
    expect(Theme.of(context).primaryColor, equals(Colors.red),
        reason:
            'theme primary color should match custom theme but it is does not.');

    manager.setDark();
    await tester.pumpAndSettle();
    expect(Theme.of(context).brightness, equals(Brightness.dark),
        reason: 'theme brightness should be dark but it is not.');
    expect(Theme.of(context).primaryColor, equals(Colors.red),
        reason: 'theme should be custom but it is not.');
    expect(manager.mode.isDark, isTrue,
        reason: 'manager.mode should be dark but it is not.');

    await manager.reset();
    await tester.pumpAndSettle();
    expect(Theme.of(context).brightness, equals(Brightness.light),
        reason: 'theme should reset to light but it did not.');
    expect(manager.brightness, equals(Theme.of(context).brightness),
        reason: 'theme should reset to light but it did not.');
    expect(Theme.of(context).primaryColor, equals(Colors.blue),
        reason: 'theme should reset to default theme but it did not.');
    expect(manager.lightTheme.primaryColor, equals(Colors.blue),
        reason:
            'light theme should reset to default light theme but it did not.');
    expect(manager.darkTheme.primaryColor, equals(Colors.blue),
        reason:
            'dark theme should reset to default dark theme but it did not.');
    expect(manager.mode.isLight, isTrue,
        reason: 'manager.mode should return light mode but it did not.');

    expect(manager.isDefault, isTrue,
        reason: 'isDefault flag should be true after resetting but it is not.');
  });

  testWidgets('Theme name tests', (tester) async {
    expect(AdaptiveThemeMode.light.modeName, equals('Light'),
        reason: 'light mode name is altered.');
    expect(AdaptiveThemeMode.dark.modeName, equals('Dark'),
        reason: 'dark mode name is altered.');
    expect(AdaptiveThemeMode.system.modeName, equals('System'),
        reason: 'system mode name is altered.');
  });

  testWidgets('persist tests', (tester) async {
    final light = ThemeData.light();
    final dark = ThemeData.dark();
    await pumpMaterialApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.dark,
    );

    final BuildContext context = tester.element(find.byType(Scaffold));
    final manager = AdaptiveTheme.of(context);

    await clearPref();
    await manager.persist();

    expect(ThemePreferences.fromPrefs(), completion(isNotNull),
        reason:
            ' manager.persist should save theme mode but retrieved one is not the same.');
    expect((await ThemePreferences.fromPrefs())!.mode.isDark, isTrue,
        reason: 'persisted mode was dark but retrieved one is not.');
  });

  testWidgets('device theme change tests', (tester) async {
    tester.view.platformDispatcher.platformBrightnessTestValue =
        Brightness.light;

    await pumpMaterialApp(
      tester,
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      mode: AdaptiveThemeMode.system,
    );

    final BuildContext context = tester.element(find.byType(Scaffold));
    final manager = AdaptiveTheme.of(context);
    expect(Theme.of(context).brightness, equals(Brightness.light),
        reason: 'initial brightness should be light but it is not.');
    expect(manager.brightness, equals(Brightness.light),
        reason: 'manager.brightness should be light but it is not.');

    tester.view.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    await tester.pumpAndSettle();
    expect(Theme.of(context).brightness, equals(Brightness.dark),
        reason:
            'when platform brightness is changed to dark, theme should be changed to dark as well but it did not.');
    expect(manager.brightness, equals(Brightness.dark),
        reason: 'manager.brightness should be dark but it is not.');

    tester.view.platformDispatcher.platformBrightnessTestValue =
        Brightness.light;
    await tester.pumpAndSettle();
    expect(Theme.of(context).brightness, equals(Brightness.light),
        reason:
            'when platform brightness is changed to light, theme should be changed to light as well but it did not.');
    expect(manager.brightness, equals(Brightness.light),
        reason: 'manager.brightness should be light but it is not.');
  });

  tearDown(() async {
    await clearPref();
  });
}
