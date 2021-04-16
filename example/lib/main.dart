import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:example/cupertino_example.dart';
import 'package:example/material_example.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isMaterial = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      child: isMaterial
          ? MaterialExample(
              savedThemeMode: widget.savedThemeMode,
              onChanged: () => setState(() => isMaterial = false))
          : CupertinoExample(
              savedThemeMode: widget.savedThemeMode,
              onChanged: () => setState(() => isMaterial = true)),
    );
  }
}
