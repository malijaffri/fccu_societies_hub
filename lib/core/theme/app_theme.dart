import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_radius.dart';

final _colorSchemeSeed = Colors.indigo;
final _cardThemeShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r_16));
const _navigationBarTheme = NavigationBarThemeData(elevation: 0, labelBehavior: .alwaysShow);
const _appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);
final _inputDecorationTheme = InputDecorationTheme(
  filled: true,
  border: OutlineInputBorder(borderRadius: .circular(AppRadius.r_14)),
);
const _textTheme = TextTheme(
  titleMedium: TextStyle(fontSize: 16, fontWeight: .w600),
  bodyLarge: TextStyle(fontSize: 16, height: 1.45),
  bodyMedium: TextStyle(fontSize: 14),
  bodySmall: TextStyle(fontSize: 12),
);

final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: .light,
  colorSchemeSeed: _colorSchemeSeed,

  scaffoldBackgroundColor: const Color(0xFFF6F7FB),

  cardTheme: .new(elevation: 1, margin: EdgeInsets.zero, shape: _cardThemeShape),
  navigationBarTheme: _navigationBarTheme,
  appBarTheme: _appBarTheme,
  inputDecorationTheme: _inputDecorationTheme,
  textTheme: _textTheme,
);

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: .dark,
  colorSchemeSeed: _colorSchemeSeed,

  scaffoldBackgroundColor: const Color(0xFF121212),

  cardTheme: .new(elevation: 0, margin: EdgeInsets.zero, shape: _cardThemeShape),
  navigationBarTheme: _navigationBarTheme,
  appBarTheme: _appBarTheme,
  inputDecorationTheme: _inputDecorationTheme,
  textTheme: _textTheme,
);
