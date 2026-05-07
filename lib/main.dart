import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() {
  runApp(const FccuSocietiesHubApp());
}

class FccuSocietiesHubApp extends StatelessWidget {
  const FccuSocietiesHubApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'FCCU Societies Hub',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: .fromSeed(seedColor: Colors.deepPurple, brightness: .light),
      useMaterial3: true,
    ),
    darkTheme: ThemeData(
      colorScheme: .fromSeed(seedColor: Colors.deepPurple, brightness: .dark),
      useMaterial3: true,
    ),
    themeMode: .system,
    home: const WelcomeScreen(),
  );
}
