# Adaptive Theme For Fluent UI

This is an extension package for [Adaptive Theme](https://pub.dev/packages/adaptive_theme) that provides support
for [Fluent UI](https://pub.dev/packages/fluent_ui). For more information,
checkout [Adaptive Theme](https://pub.dev/packages/adaptive_theme) docs.

## Getting Started

add following dependencies to your `pubspec.yaml`

```yaml
dependencies:
  adaptive_theme: <latest_version>
  adaptive_theme_fluent_ui: <latest_version>
```

## How to use

```dart
import 'package:fluent_ui/fluent_ui.dart';

FluentAdaptiveTheme(
  light: FluentThemeData.light(),
  dark: FluentThemeData.dark(),
  initial: savedThemeMode ?? AdaptiveThemeMode.light,
  builder: (theme, darkTheme) => FluentApp(
    title: 'Fluent Adaptive Theme Demo',
    theme: theme,
    darkTheme: darkTheme,
    home: MyHomePage(),
  ),
);
```

Checkout [Adaptive Theme](https://pub.dev/packages/adaptive_theme) for more information.

## Contribution

You are most welcome to contribute to this project!

Please have a look
at [Contributing Guidelines](https://github.com/BirjuVachhani/adaptive_theme_fluent_ui/blob/main/CONTRIBUTING.md), before
contributing and proposing a change.

#### Liked Adaptive Theme?

Show some love and support by starring the repository.

Or You can

<a href="https://www.buymeacoffee.com/birjuvachhani" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-blue.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>

## License

```
Copyright © 2022 Birju Vachhani

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
