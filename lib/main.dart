import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() {
  runApp(const FccuSocietiesHubApp());
}

class FccuSocietiesHubApp extends StatelessWidget {
  const FccuSocietiesHubApp({super.key});

  static const bool useDynamic = false;

  @override
  Widget build(BuildContext context) => DynamicColorBuilder(
    builder: (lightDynamic, darkDynamic) {
      final ColorScheme lightScheme;
      final ColorScheme darkScheme;

      if (useDynamic && lightDynamic != null && darkDynamic != null) {
        lightScheme = lightDynamic;
        darkScheme = darkDynamic;
      } else {
        lightScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light);
        darkScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark);
      }

      return MaterialApp(
        title: 'FCCU Societies Hub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorScheme: lightScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkScheme),
        themeMode: ThemeMode.system,
        home: const WelcomeScreen(),
      );
    },
  );
}
