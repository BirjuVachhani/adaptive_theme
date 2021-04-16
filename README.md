![adaptive_theme](https://github.com/BirjuVachhani/adaptive_theme/blob/main/banner.png)

# Adaptive Theme

Easiest way to add support for **light** and **dark** theme in your Flutter app. It allows to manually set light or dark theme and also lets you define
themes based on the system. It also persists the theme modes changes across app restarts.

[![pub dev CD](https://github.com/BirjuVachhani/adaptive_theme/workflows/Publish%20Package/badge.svg?branch=main)](https://github.com/BirjuVachhani/adaptive_theme/actions) [![adaptive_theme](https://img.shields.io/pub/v/adaptive_theme?label=adaptive_theme)](https://pub.dev/packages/adaptive_theme)



## Index

- **[Getting Started](#Getting-Started)**
- **[Initialization](#Initialization)**
- **[Changing Theme Mode](#Changing-Theme-Mode)**
- **[Toggle Theme Mode](#Toggle-Theme-Mode)**
- **[Changing Themes](#Changing-Themes)**
- **[Reset Theme](#Reset-Theme)**
- **[Set Default Theme](#Set-Default-Theme)**
- **[Handling App Start](#Get-ThemeMode-at-App-Start)**
- **[Handling Theme Changes](#Listen-to-the-theme-mode-changes)**
- **[Ceveats](#Ceveats)**
  - [Non-Persist theme changes](#Non-Persist-theme-changes)
  - [Using SharedPreferences](#Using-SharedPreferences)
- **[Using-CupertinoTheme](#Using-CupertinoTheme)**
  - [Changing Cupertino Theme](#Changing-Cupertino-Theme)
- **[License](#License)**


## Getting Started

add following dependency to your `pubspec.yaml`

```yaml
dependencies:
  adaptive_theme: <latest_version>
```



## Initialization

You need to wrap your `MaterialApp` with `AdaptiveTheme` in order to apply themes.

```dart
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        accentColor: Colors.amber,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        accentColor: Colors.amber,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        home: MyHomePage(),
      ),
    );
  }
}
```



## Changing Theme Mode

Now that you have initialized your app as mentioned above. It's very easy and straight forward to change your theme modes: **light to dark, dark to light or to system default**.

```dart
// sets theme mode to dark
AdaptiveTheme.of(context).setDark();

// sets theme mode to light
AdaptiveTheme.of(context).setLight();

// sets theme mode to system default
AdaptiveTheme.of(context).setSystem();
```



## Toggle Theme Mode

`AdaptiveTheme` allows you to toggle between light, dark and system theme the easiest way possible.

```dart
AdaptiveTheme.of(context).toggleThemeMode();
```



## Changing Themes

If you want to change the theme entirely like change all the colors to some other color swatch, then you can use `setTheme` method.

```dart
AdaptiveTheme.of(context).setTheme(
  light: ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.purple,
    accentColor: Colors.amber,
  ),
  dark: ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.purple,
    accentColor: Colors.amber,
  ),
);
```



## Reset Theme

`AdaptiveTheme` is smart enough to keep your **default** themes handy that you provided at the time of initialization. You can fallback to those default themes in a very easy way.

```dart
AdaptiveTheme.of(context).reset();
```

This will reset your **theme** as well as **theme mode** to the **initial** values provided at the time of initialization.



## Set Default Theme

`AdaptiveTheme` persists theme mode changes across app restarts and uses the default themes to set theme modes(light/dark) on. You can change this behavior if you want to set a different theme as default theme other then the one provided at the time of initialization.

This comes handy when you're fetching themes remotely on app starts and setting theme as current theme.

Doing so is quit easy. You would set a new theme normally as you do by calling `setTheme` method but this time, with a flag `isDefault` set to true.

> This is only useful when you might want to reset to default theme at some point.

```dart
AdaptiveTheme.of(context).setTheme(
  light: ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    accentColor: Colors.amber,
  ),
  dark: ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    accentColor: Colors.amber,
  ),
  isDefault: true,
);
```



## Get ThemeMode at App Start

When you change your theme, next app run won't be able to pick the most recent theme directly before rendering with default theme first time. This is because at time of initialization, we cannot run async code to get previous theme mode. However it can be avoided if you make your `main()` method async and load previous theme mode asynchronously. Below example shows how it can be done.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}
```

```dart
AdaptiveTheme(
  light: lightTheme,
  dark: darkTheme,
  initial: savedThemeMode ?? AdaptiveThemeMode.light,
  builder: (theme, darkTheme) => MaterialApp(
    title: 'Adaptive Theme Demo',
    theme: theme,
    darkTheme: darkTheme,
    home: MyHomePage(),
  ),
)
```
Notice that I passed the retrieved theme mode to my material app so that I can use it while initializing the default theme. This helps avoiding theme change flickering on app startup.



## Listen to the theme mode changes

You can listen to the changes in the theme mode via a `ValueNotifier`. This can be useful when designing theme settings screen or developing ui to show theme status.

```dart
AdaptiveTheme.of(context).modeChangeNotifier.addListener(() {
  // do your thing.
});
```

Or you can utilize it to react on UI with

```dart
ValueListenableBuilder(
  valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
  builder: (_, mode, child) {
    // update your UI
    return Container();
  },
);
```


## Ceveats

#### Non-Persist theme changes

> This is only useful in scenarios where you load your themes dynamically from network in the splash screen or some initial screens of the app. Please note that `AdaptiveTheme` does not persist the themes, it only persists the theme modes(light/dark/system). Any changes made to the provided themes won't be persisted and you will have to do the same changes at the time of the initialization if you want them to apply every time app is opened. e.g changing the accent color.



#### Using SharedPreferences

> This package uses [shared_preferences](https://pub.dev/packages/shared_preferences) plugin internally to persist theme mode changes. If your app uses [shared_preferences](https://pub.dev/packages/shared_preferences) which might be the case all the time, clearing your [shared_preferences](https://pub.dev/packages/shared_preferences) at the time of logging out or signing out might clear these preferences too. Be careful not to clear these preferences if you want it to be persisted.

```dart
/// Do not remove this key from preferences
AdaptiveTheme.prefKey
```

You can use above key to exclude it while clearing the all the preferences.

Or you can call `AdaptiveTheme.persist()` method after clearing the preferences to make it persistable again as shown below.

```dart
final prefs = await SharedPreferences.getInstance();
await pref.clear();
AdaptiveTheme.persist();
```

## Using CupertinoTheme

Wrap your `CupertinoApp` with `CupertinoAdaptiveTheme` in order to apply themes.

```dart
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoAdaptiveTheme(
      light: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      dark: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme) => CupertinoApp(
        title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        home: MyHomePage(),
      ),
    );
  }
}
```

#### Changing Cupertino Theme

```dart
// sets dark theme
CupertinoAdaptiveTheme.of(context).setDark();

// sets light theme
CupertinoAdaptiveTheme.of(context).setLight();

// sets system default theme
CupertinoAdaptiveTheme.of(context).setSystem();
```

## License

```
Copyright © 2020 Birju Vachhani

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
