import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adaptive_theme/src/adaptive_theme_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_utils.dart';

void main() {
  const light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.systemBlue,
  );
  const dark = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.systemBlue,
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('CupertinoAdaptiveTheme initial light theme test',
      (tester) async {
    await pumpCupertinoApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    final BuildContext context =
        tester.element(find.byType(CupertinoPageScaffold));

    expect(CupertinoTheme.of(context).brightness, equals(Brightness.light),
        reason: 'initial theme was set to light but actual is different.');
  });

  testWidgets('CupertinoAdaptiveTheme initial dark theme test', (tester) async {
    await pumpCupertinoApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.dark,
    );

    final BuildContext context =
        tester.element(find.byType(CupertinoPageScaffold));

    expect(CupertinoTheme.of(context).brightness, equals(Brightness.dark),
        reason: 'initial theme was set to dark but actual is different.');
  });

  testWidgets('CupertinoAdaptiveTheme load saved prefs test', (tester) async {
    final initialData = {
      'theme_mode': AdaptiveThemeMode.dark.index,
      'default_theme_mode': AdaptiveThemeMode.light.index,
    };
    SharedPreferences.setMockInitialValues({
      CupertinoAdaptiveTheme.prefKey: json.encode(initialData),
    });

    await pumpCupertinoApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    await tester.pumpAndSettle();

    final BuildContext context =
        tester.element(find.byType(CupertinoPageScaffold));

    expect(CupertinoTheme.of(context).brightness, equals(Brightness.dark),
        reason: 'initial theme was set to dark but actual is different.');
    expect(CupertinoAdaptiveTheme.of(context).mode.isDark, isTrue,
        reason: 'saved mode was dark but loaded mode is different.');
  });

  testWidgets('CupertinoAdaptiveThemeManager retrieval tests', (tester) async {
    await pumpCupertinoApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    BuildContext context = tester.element(find.byType(CupertinoPageScaffold));
    expect(CupertinoAdaptiveTheme.of(context),
        isA<CupertinoAdaptiveThemeManager>(),
        reason:
            'CupertinoAdaptiveTheme.of should return instance of CupertinoAdaptiveThemeManager but actually returned something else.');
    expect(CupertinoAdaptiveTheme.maybeOf(context), isNotNull,
        reason:
            'CupertinoAdaptiveTheme.maybeOf should not return null but it did.');
    expect(CupertinoAdaptiveTheme.maybeOf(context),
        isA<CupertinoAdaptiveThemeManager>(),
        reason:
            'CupertinoAdaptiveTheme.maybeOf should return instance of CupertinoAdaptiveThemeManager but actually returned something else.');

    await tester.pumpWidget(Container());
    context = tester.element(find.byType(Container));

    expect(() => CupertinoAdaptiveTheme.of(context), throwsA(anything),
        reason:
            'CupertinoAdaptiveTheme.of should throw when not located in widget tree but it did not.');
    expect(CupertinoAdaptiveTheme.maybeOf(context), isNull,
        reason:
            'CupertinoAdaptiveTheme.maybeOf should be null and not throwing when not located in widget tree but it returned something else.');
  });

  testWidgets('CupertinoAdaptiveTheme.getThemeMode() Tests', (tester) async {
    expect(CupertinoAdaptiveTheme.getThemeMode(), completes);
    expect(CupertinoAdaptiveTheme.getThemeMode(), completion(isNull));

    await pumpCupertinoApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    expect(CupertinoAdaptiveTheme.getThemeMode(), completes,
        reason: 'getThemeMode should complete without fail but it did not.');
    expect(CupertinoAdaptiveTheme.getThemeMode(), completion(isNotNull),
        reason:
            'getThemeMode should return a non-null value but it returned null.');
    expect(CupertinoAdaptiveTheme.getThemeMode(),
        completion(equals(AdaptiveThemeMode.light)),
        reason:
            'getThemeMode should return light mode but it returned something else.');
  });

  testWidgets('theme, lightTheme, darkTheme and mode Tests', (tester) async {
    await pumpCupertinoApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    final BuildContext context =
        tester.element(find.byType(CupertinoPageScaffold));
    final manager = CupertinoAdaptiveTheme.of(context);

    expect(manager.theme.brightness, equals(light.brightness),
        reason: 'manager.theme should be light but it is not.');
    expect(manager.lightTheme.brightness, equals(light.brightness),
        reason: 'manager.lightTheme should be light but it is not.');
    expect(manager.darkTheme.brightness, equals(dark.brightness),
        reason: 'manager.darkTheme should be dark but it is not.');
    expect(manager.mode, equals(AdaptiveThemeMode.light),
        reason: 'manager.mode should be light mode but it is not.');

    manager.setDark();
    await tester.pumpAndSettle();
    expect(manager.theme.brightness, equals(dark.brightness),
        reason:
            'manager.theme should be dark after setting dark theme but it is not.');
    expect(manager.mode, equals(AdaptiveThemeMode.dark),
        reason: 'manager.mode should be dark but it is not.');
  });

  testWidgets('toggleThemeMode Tests', (tester) async {
    await pumpCupertinoApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    final BuildContext context =
        tester.element(find.byType(CupertinoPageScaffold));
    final manager = CupertinoAdaptiveTheme.of(context);

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

  testWidgets('setThemeMode Tests', (tester) async {
    await pumpCupertinoApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    final BuildContext context =
        tester.element(find.byType(CupertinoPageScaffold));
    final manager = CupertinoAdaptiveTheme.of(context);

    expect(manager.mode, equals(AdaptiveThemeMode.light),
        reason: 'manager.mode should be light mode but it is not.');
    expect(CupertinoTheme.of(context).brightness, equals(Brightness.light),
        reason: 'theme brightness should be light mode but it is not.');

    manager.setThemeMode(AdaptiveThemeMode.dark);
    await tester.pumpAndSettle();
    expect(manager.mode, equals(AdaptiveThemeMode.dark),
        reason: 'manager.mode should be dark mode but it is not.');
    expect(CupertinoTheme.of(context).brightness, equals(Brightness.dark),
        reason: 'theme brightness should be dark mode but it is not.');

    manager.setThemeMode(AdaptiveThemeMode.system);
    await tester.pumpAndSettle();
    expect(manager.mode, equals(AdaptiveThemeMode.system),
        reason: 'manager.mode should be system mode but it is not.');

    manager.setLight();
    await tester.pumpAndSettle();
    expect(manager.mode.isLight, isTrue,
        reason: 'manager.mode should be light mode but it is not.');
    expect(CupertinoTheme.of(context).brightness, equals(Brightness.light),
        reason: 'theme brightness should be light mode but it is not.');

    manager.setDark();
    await tester.pumpAndSettle();
    expect(manager.mode.isDark, isTrue,
        reason: 'manager.mode should be dark mode but it is not.');
    expect(CupertinoTheme.of(context).brightness, equals(Brightness.dark),
        reason: 'theme brightness should be dark mode but it is not.');

    manager.setSystem();
    await tester.pumpAndSettle();
    expect(manager.mode.isSystem, isTrue,
        reason: 'manager.mode should be system mode but it is not.');
  });

  testWidgets('custom theme and reset Tests', (tester) async {
    await pumpCupertinoApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.light,
    );

    final BuildContext context = tester.element(find.byType(Center));
    final manager = CupertinoAdaptiveTheme.of(context);

    manager.setTheme(
        light: const CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: CupertinoColors.systemRed,
        ),
        dark: const CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: CupertinoColors.activeGreen,
        ));

    await tester.pumpAndSettle();
    expect(manager.isDefault, isFalse,
        reason:
            'after setting custom theme, manager.isDefault should not be true but it is.');
    expect(manager.lightTheme.brightness, equals(Brightness.light));
    expect(manager.darkTheme.brightness, equals(Brightness.dark));

    expect(manager.lightTheme.primaryColor, equals(CupertinoColors.systemRed),
        reason:
            'manager.lightTheme should hold custom light theme but it does not.');
    expect(manager.darkTheme.primaryColor, equals(CupertinoColors.activeGreen),
        reason:
            'manager.lightTheme should hold custom dark theme but it does not.');

    expect(CupertinoTheme.of(context).brightness, equals(Brightness.light),
        reason: 'theme brightness should be light mode but it is not.');
    expect(CupertinoTheme.of(context).primaryColor,
        equals(CupertinoColors.systemRed),
        reason:
            'theme primary color should match custom theme but it is does not.');

    manager.setDark();
    await tester.pumpAndSettle();
    expect(CupertinoTheme.of(context).brightness, equals(Brightness.dark),
        reason: 'theme brightness should be dark but it is not.');
    expect(manager.mode.isDark, isTrue,
        reason: 'manager.mode should be dark but it is not.');

    await manager.reset();
    await tester.pumpAndSettle();
    expect(CupertinoTheme.of(context).brightness, equals(Brightness.light),
        reason: 'theme should reset to light but it did not.');
    expect(manager.brightness, equals(CupertinoTheme.of(context).brightness),
        reason: 'theme should reset to light but it did not.');
    expect(CupertinoTheme.of(context).primaryColor,
        equals(CupertinoColors.systemBlue),
        reason: 'theme should reset to default theme but it did not.');
    expect(manager.lightTheme.primaryColor, equals(CupertinoColors.systemBlue),
        reason:
            'light theme should reset to default light theme but it did not.');
    expect(manager.darkTheme.primaryColor, equals(CupertinoColors.systemBlue),
        reason:
            'dark theme should reset to default dark theme but it did not.');
    expect(manager.mode.isLight, isTrue,
        reason: 'manager.mode should return light mode but it did not.');

    expect(manager.isDefault, isTrue,
        reason: 'isDefault flag should be true after resetting but it is not.');
  });

  testWidgets('persist tests', (tester) async {
    await pumpCupertinoApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.dark,
    );

    final BuildContext context =
        tester.element(find.byType(CupertinoPageScaffold));
    final manager = CupertinoAdaptiveTheme.of(context);

    await clearPref();
    await manager.persist();

    expect(ThemePreferences.fromPrefs(), completion(isNotNull),
        reason:
            ' manager.persist should save theme mode but retrieved one is not the same.');
    expect((await ThemePreferences.fromPrefs())!.mode.isDark, isTrue,
        reason: 'persisted mode was dark but retrieved one is not.');
  });

  testWidgets('device theme change tests', (tester) async {
    tester.binding.window.platformDispatcher.platformBrightnessTestValue =
        Brightness.light;

    await pumpCupertinoApp(
      tester,
      light: light,
      dark: dark,
      mode: AdaptiveThemeMode.system,
    );

    final BuildContext context =
        tester.element(find.byType(CupertinoPageScaffold));
    final manager = CupertinoAdaptiveTheme.of(context);
    expect(CupertinoTheme.of(context).brightness, equals(Brightness.light),
        reason: 'initial brightness should be light but it is not.');
    expect(manager.brightness, equals(Brightness.light),
        reason: 'manager.brightness should be light but it is not.');

    tester.binding.window.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    await tester.pumpAndSettle();
    expect(CupertinoTheme.of(context).brightness, equals(Brightness.dark),
        reason:
            'when platform brightness is changed to dark, theme should be changed to dark as well but it did not.');
    expect(manager.brightness, equals(Brightness.dark),
        reason: 'manager.brightness should be dark but it is not.');

    tester.binding.window.platformDispatcher.platformBrightnessTestValue =
        Brightness.light;
    await tester.pumpAndSettle();
    expect(CupertinoTheme.of(context).brightness, equals(Brightness.light),
        reason:
            'when platform brightness is changed to light, theme should be changed to light as well but it did not.');
    expect(manager.brightness, equals(Brightness.light),
        reason: 'manager.brightness should be light but it is not.');
  });

  tearDown(() async {
    await clearPref();
  });
}
