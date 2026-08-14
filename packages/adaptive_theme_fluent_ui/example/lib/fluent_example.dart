// Author: Birju Vachhani
// Created Date: April 20, 2022

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adaptive_theme_fluent_ui/adaptive_theme_fluent_ui.dart';
import 'package:fluent_ui/fluent_ui.dart';

class FluentExample extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const FluentExample({
    super.key,
    this.savedThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    return FluentAdaptiveTheme(
      light: FluentThemeData.light(),
      dark: FluentThemeData.dark(),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      debugShowFloatingThemeButton: true,
      builder: (theme, darkTheme) => FluentApp(
        title: 'Fluent Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        home: MyHomePage(key: ValueKey(theme)),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedFluentTheme(
      data: FluentTheme.of(context),
      child: NavigationView(
        pane: NavigationPane(
          displayMode: PaneDisplayMode.compact,
          items: [
            PaneItem(
              icon: const Icon(FluentIcons.home),
              title: const Text('Home'),
              body: const Body(),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.contact),
              title: const Text('Contacts'),
              body: const Center(child: Text('Contacts')),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.accounts),
              title: const Text('Accounts'),
              body: const Center(child: Text('Accounts')),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.settings),
              title: const Text('Settings'),
              body: const Center(child: Text('Settings')),
            ),
          ],
          selected: currentIndex,
          onChanged: (index) {
            setState(() => currentIndex = index);
          },
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              FluentAdaptiveTheme.of(context).mode.modeName.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                height: 2.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () =>
                  FluentAdaptiveTheme.of(context).toggleThemeMode(),
              child: const Text('Toggle Theme Mode'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => FluentAdaptiveTheme.of(context).setDark(),
              child: const Text('Set Dark'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => FluentAdaptiveTheme.of(context).setLight(),
              child: const Text('set Light'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => FluentAdaptiveTheme.of(context).setSystem(),
              child: const Text('Set System Default'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => FluentAdaptiveTheme.of(context).setTheme(
                light: FluentThemeData(
                  brightness: Brightness.light,
                  accentColor: Colors.red,
                ),
                dark: FluentThemeData(
                  brightness: Brightness.dark,
                  accentColor: Colors.red,
                ),
              ),
              child: const Text('Set Custom Theme'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => FluentAdaptiveTheme.of(context).reset(),
              child: const Text('Reset to Default Themes'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
