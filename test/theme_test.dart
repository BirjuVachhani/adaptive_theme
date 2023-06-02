// Copyright © 2023 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('device theme change test', (tester) async {
    tester.view.platformDispatcher.platformBrightnessTestValue =
        Brightness.light;
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Theme Test'),
        ),
        body: const Center(
          child: Text('Hello'),
        ),
      ),
    ));
    // checking current brightness
    final BuildContext context = tester.element(find.byType(Scaffold));
    expect(Theme.of(context).brightness, Brightness.light);
    expect(tester.view.platformDispatcher.platformBrightness, Brightness.light);
    expect(WidgetsBinding.instance.platformDispatcher.platformBrightness,
        Brightness.light);
    // change brightness to dark
    tester.view.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    await tester.pumpAndSettle();
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(tester.view.platformDispatcher.platformBrightness, Brightness.dark);
    expect(WidgetsBinding.instance.platformDispatcher.platformBrightness,
        Brightness.dark,
        reason: 'This returns light but it should return dark.');
  });
}
