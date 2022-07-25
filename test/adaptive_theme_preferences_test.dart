// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adaptive_theme/src/adaptive_theme_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemePreferences Tests', () {
    setUp(() async {
      // clear preference before running each tests
      SharedPreferences.setMockInitialValues({});
      final pref = await SharedPreferences.getInstance();
      await pref.clear();
    });

    test('theme preferences fromPref tests when not set', () async {
      expect(ThemePreferences.fromPrefs(), completion(isNull),
          reason: 'should be null initially!');
      expect(ThemePreferences.fromPrefs(), completes,
          reason:
              'fromPrefs() should complete without any exceptions when no data is set to preferences.');
    });

    test('theme preferences fromPref tests when invalid data is set', () async {
      SharedPreferences.setMockInitialValues({
        AdaptiveTheme.prefKey: 'text',
      });

      expect(ThemePreferences.fromPrefs(), completes,
          reason:
              'fromPrefs() should complete without any exceptions when invalid data is set to preferences.');
    });

    test('theme preferences fromPref tests when set', () async {
      final initialData = {
        'theme_mode': AdaptiveThemeMode.dark.index,
        'default_theme_mode': AdaptiveThemeMode.light.index,
      };
      SharedPreferences.setMockInitialValues({
        AdaptiveTheme.prefKey: json.encode(initialData),
      });
      expect(ThemePreferences.fromPrefs(), completion(isNotNull),
          reason:
              'fromPrefs() must not return null when there is data in shared preferences');
      expect(ThemePreferences.fromPrefs(), completes,
          reason:
              'fromPrefs() should complete without any exceptions when data is set to preferences.');

      final retrieved = await ThemePreferences.fromPrefs();
      expect(retrieved!.mode, equals(AdaptiveThemeMode.dark),
          reason:
              'Saved theme mode was dark but fromPrefs() loaded something else.');
      expect(retrieved.defaultMode, equals(AdaptiveThemeMode.light),
          reason:
              'Saved default theme mode was light but fromPrefs() loaded something else.');
    });

    test('theme preferences fromPref tests when default mode is not set',
        () async {
      final initialData = {
        'theme_mode': AdaptiveThemeMode.dark.index,
      };
      SharedPreferences.setMockInitialValues({
        AdaptiveTheme.prefKey: json.encode(initialData),
      });

      final retrieved = await ThemePreferences.fromPrefs();
      expect(retrieved!.mode, equals(AdaptiveThemeMode.dark),
          reason:
              'Saved theme mode was dark but fromPrefs() loaded something else.');
      expect(retrieved.defaultMode, equals(AdaptiveThemeMode.dark),
          reason:
              'When no default mode is saved, it should same as current mode.');
    });

    test('ThemePreferences.initial tests', () async {
      expect(ThemePreferences.initial(mode: AdaptiveThemeMode.dark).defaultMode,
          equals(AdaptiveThemeMode.dark),
          reason:
              'ThemePreferences.initial also initialize default mode to be same as current mode.');
    });

    test('ThemePreferences save() tests', () async {
      expect(ThemePreferences.fromPrefs(), completion(isNull),
          reason: 'ThemePreferences should be null initially.');

      expect(ThemePreferences.initial().save(), completes,
          reason: 'save() should complete without throwing.');

      expect(ThemePreferences.fromPrefs(), completion(isNotNull),
          reason:
              'once preferences are saved, fromPrefs() should not return null.');

      final retrieved = await ThemePreferences.fromPrefs();
      expect(retrieved!.mode, equals(AdaptiveThemeMode.light),
          reason: 'saved mode was light but retrieved one is different.');
      expect(retrieved.defaultMode, equals(AdaptiveThemeMode.light),
          reason:
              'saved default mode was light but retrieved one is different.');
    });

    test('ThemePreferences reset() tests', () async {
      final initialData = {
        'theme_mode': AdaptiveThemeMode.dark.index,
        'default_theme_mode': AdaptiveThemeMode.system.index,
      };
      SharedPreferences.setMockInitialValues({
        AdaptiveTheme.prefKey: json.encode(initialData),
      });

      final retrieved = await ThemePreferences.fromPrefs();
      expect(retrieved, isNotNull,
          reason:
              'fromPrefs() should not return null when some data is already saved.');
      expect(retrieved!.mode, equals(AdaptiveThemeMode.dark),
          reason: 'dark mode was saved but retrieved one is different.');
      expect(retrieved.defaultMode, equals(AdaptiveThemeMode.system),
          reason:
              'default system mode was saved but retrieved one is different.');

      retrieved.reset();
      expect(retrieved.mode, equals(AdaptiveThemeMode.system),
          reason:
              'reset() should have reset mode to default mode but it did not.');
    });

    tearDown(() async {
      // clear preference after running each test
      final pref = await SharedPreferences.getInstance();
      await pref.clear();
    });
  });
}
