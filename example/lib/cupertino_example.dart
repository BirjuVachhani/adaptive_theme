// Author: Birju Vachhani
// Created Date: April 16, 2021

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';

class CupertinoExample extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final VoidCallback onChanged;

  const CupertinoExample({
    super.key,
    this.savedThemeMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAdaptiveTheme(
      light: const CupertinoThemeData(brightness: Brightness.light),
      dark: const CupertinoThemeData(brightness: Brightness.dark),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme) => CupertinoApp(
        title: 'Adaptive Theme Demo',
        theme: theme,
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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Cupertino Example'),
      ),
      child: SafeArea(
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
                CupertinoAdaptiveTheme.of(context).mode.modeName.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  height: 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              CupertinoButton.filled(
                onPressed: () =>
                    CupertinoAdaptiveTheme.of(context).toggleThemeMode(),
                child: const Text('Toggle Theme Mode'),
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: () => CupertinoAdaptiveTheme.of(context).setDark(),
                child: const Text('Set Dark'),
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: () => CupertinoAdaptiveTheme.of(context).setLight(),
                child: const Text('set Light'),
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: () => CupertinoAdaptiveTheme.of(context).setSystem(),
                child: const Text('Set System Default'),
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: () =>
                    CupertinoAdaptiveTheme.maybeOf(context)?.setTheme(
                  light: const CupertinoThemeData(
                      brightness: Brightness.light,
                      primaryColor: CupertinoColors.destructiveRed),
                  dark: const CupertinoThemeData(
                      brightness: Brightness.dark,
                      primaryColor: CupertinoColors.destructiveRed),
                ),
                child: const Text('Set Custom Theme'),
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: () => CupertinoAdaptiveTheme.of(context).reset(),
                child: const Text('Reset to Default Themes'),
              ),
              const Spacer(flex: 2),
              CupertinoButton(
                onPressed: widget.onChanged,
                child: const Text('Switch to Material Example'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
