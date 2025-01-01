// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../adaptive_theme.dart';

/// An inherited widget that saves provides current mode, theme, dark theme and
/// brightness to its children.
/// This is an internal widget and should not be used directly.
class InheritedAdaptiveTheme<T extends Object> extends InheritedWidget {
  final AdaptiveThemeMode mode;
  final T theme;
  final T darkTheme;
  final Brightness? brightness;

  InheritedAdaptiveTheme({
    super.key,
    required AdaptiveThemeManager<T> manager,
    required super.child,
  })  : mode = manager.mode,
        theme = manager.theme,
        darkTheme = manager.darkTheme,
        brightness = manager.brightness;

  @override
  bool updateShouldNotify(covariant InheritedAdaptiveTheme<T> oldWidget) {
    return oldWidget.mode != mode ||
        oldWidget.theme != theme ||
        oldWidget.darkTheme != darkTheme ||
        oldWidget.brightness != brightness;
  }
}
