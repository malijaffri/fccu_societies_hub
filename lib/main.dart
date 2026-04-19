import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() {
  runApp(const FccuSocietiesHubApp());
}

class FccuSocietiesHubApp extends StatelessWidget {
  const FccuSocietiesHubApp({super.key});

  @override
  Widget build(BuildContext context) => DynamicColorBuilder(
    builder: (lightDynamic, darkDynamic) => MaterialApp(
      title: 'FCCU Societies Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkDynamic ?? ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
    ),
  );
}
