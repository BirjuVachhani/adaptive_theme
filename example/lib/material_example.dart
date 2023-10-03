// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: April 16, 2021

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class MaterialExample extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final VoidCallback onChanged;

  const MaterialExample({
    super.key,
    this.savedThemeMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(
        useMaterial3: true,
      ),
      dark: ThemeData.dark(
        useMaterial3: true,
      ),
      debugShowFloatingThemeButton: true,
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        home: MyHomePage(onChanged: onChanged),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final VoidCallback onChanged;

  const MyHomePage({super.key, required this.onChanged});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Material Example'),
        ),
        body: SafeArea(
          child: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Text(
                  'Current Theme Mode',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  AdaptiveTheme.of(context).mode.modeName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    height: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () => AdaptiveTheme.of(context).toggleThemeMode(),
                  style: ElevatedButton.styleFrom(
                    visualDensity:
                        const VisualDensity(horizontal: 4, vertical: 2),
                  ),
                  child: const Text('Toggle Theme Mode'),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => AdaptiveTheme.of(context).setDark(),
                  style: ElevatedButton.styleFrom(
                    visualDensity:
                        const VisualDensity(horizontal: 4, vertical: 2),
                  ),
                  child: const Text('Set Dark'),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => AdaptiveTheme.of(context).setLight(),
                  style: ElevatedButton.styleFrom(
                    visualDensity:
                        const VisualDensity(horizontal: 4, vertical: 2),
                  ),
                  child: const Text('set Light'),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => AdaptiveTheme.of(context).setSystem(),
                  style: ElevatedButton.styleFrom(
                    visualDensity:
                        const VisualDensity(horizontal: 4, vertical: 2),
                  ),
                  child: const Text('Set System Default'),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => AdaptiveTheme.of(context).setTheme(
                    light: ThemeData(
                      useMaterial3: true,
                      colorSchemeSeed: Colors.pink,
                      brightness: Brightness.light,
                    ),
                    dark: ThemeData(
                      useMaterial3: true,
                      brightness: Brightness.dark,
                      colorSchemeSeed: Colors.pink,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    visualDensity:
                        const VisualDensity(horizontal: 4, vertical: 2),
                  ),
                  child: const Text('Set Custom Theme'),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => AdaptiveTheme.of(context).reset(),
                  style: ElevatedButton.styleFrom(
                    visualDensity:
                        const VisualDensity(horizontal: 4, vertical: 2),
                  ),
                  child: const Text('Reset to Default Themes'),
                ),
                const Spacer(flex: 2),
                TextButton(
                  onPressed: widget.onChanged,
                  child: const Text('Switch to Cupertino Example'),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
