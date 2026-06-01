import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_colors.dart';
import 'package:fccu_societies_hub/core/theme/app_radius.dart';

final _lightColorScheme = ColorScheme(
  brightness: .light,

  primary: AppColors.primary,
  onPrimary: Colors.white,

  secondary: AppColors.secondary,
  onSecondary: Colors.black,

  error: AppColors.error,
  onError: Colors.white,

  surface: AppColors.lightSurface,
  onSurface: const .new(0xFF111111),

  primaryContainer: const .new(0xFFBDEBDD),
  onPrimaryContainer: const .new(0xFF0B3D34),

  secondaryContainer: const .new(0xFFDDF7EA),
  onSecondaryContainer: const .new(0xFF10352D),

  outline: AppColors.lightBorder,

  surfaceContainerLowest: Colors.white,
  surfaceContainerLow: const .new(0xFFF8FCFA),
  surfaceContainer: const .new(0xFFF2F8F5),
  surfaceContainerHigh: const .new(0xFFEAF3EF),
  surfaceContainerHighest: const .new(0xFFE2EEEA),
);

final _darkColorScheme = ColorScheme(
  brightness: .dark,

  primary: AppColors.secondary,
  onPrimary: Colors.black,

  secondary: AppColors.primary,
  onSecondary: Colors.white,

  error: AppColors.error,
  onError: Colors.white,

  surface: AppColors.darkSurface,
  onSurface: Colors.white,

  primaryContainer: const .new(0xFF1A4E43),
  onPrimaryContainer: const .new(0xFFC8F2E6),

  secondaryContainer: const .new(0xFF24443A),
  onSecondaryContainer: const .new(0xFFD9F7EC),

  outline: AppColors.darkBorder,

  surfaceContainerLowest: const .new(0xFF101614),
  surfaceContainerLow: const .new(0xFF141B18),
  surfaceContainer: const .new(0xFF18201D),
  surfaceContainerHigh: const .new(0xFF1D2723),
  surfaceContainerHighest: const .new(0xFF24302B),
);

const _appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
  scrolledUnderElevation: 0,
  backgroundColor: Colors.transparent,
);

final _cardShape = RoundedRectangleBorder(borderRadius: .circular(AppRadius.r_16));

final _fabShape = RoundedRectangleBorder(borderRadius: .circular(AppRadius.r_16));

const _textTheme = TextTheme(
  headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),

  titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),

  titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),

  bodyLarge: TextStyle(fontSize: 16, height: 1.5),

  bodyMedium: TextStyle(fontSize: 14, height: 1.45),

  bodySmall: TextStyle(fontSize: 12, height: 1.4),
);

final lightTheme = ThemeData(
  useMaterial3: true,

  brightness: .light,

  colorScheme: _lightColorScheme,

  scaffoldBackgroundColor: AppColors.lightBackground,

  textTheme: _textTheme,

  appBarTheme: _appBarTheme,

  cardTheme: CardThemeData(elevation: 0, margin: .zero, color: Colors.white, shape: _cardShape),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,

    fillColor: Colors.white,

    contentPadding: const .symmetric(horizontal: 16, vertical: 14),

    border: OutlineInputBorder(
      borderRadius: .circular(AppRadius.r_14),

      borderSide: .new(color: _lightColorScheme.outline),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: .circular(AppRadius.r_14),

      borderSide: .new(color: _lightColorScheme.outline),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: .circular(AppRadius.r_14),

      borderSide: .new(color: _lightColorScheme.primary, width: 1.5),
    ),
  ),

  navigationBarTheme: NavigationBarThemeData(
    elevation: 0,

    backgroundColor: AppColors.lightSurface,

    indicatorColor: _lightColorScheme.secondaryContainer,

    labelBehavior: .alwaysShow,
  ),

  floatingActionButtonTheme: .new(
    elevation: 1,

    backgroundColor: _lightColorScheme.primary,

    foregroundColor: _lightColorScheme.onPrimary,

    shape: _fabShape,
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,

  brightness: .dark,

  colorScheme: _darkColorScheme,

  scaffoldBackgroundColor: AppColors.darkBackground,

  textTheme: _textTheme,

  appBarTheme: _appBarTheme,

  cardTheme: CardThemeData(elevation: 0, margin: .zero, color: AppColors.darkSurface, shape: _cardShape),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,

    fillColor: const .new(0xFF1D2723),

    contentPadding: const .symmetric(horizontal: 16, vertical: 14),

    border: OutlineInputBorder(
      borderRadius: .circular(AppRadius.r_14),

      borderSide: .new(color: _darkColorScheme.outline),
    ),

    // enabledBorder: OutlineInputBorder(
    //   borderRadius: .circular(AppRadius.r_14),
    //
    //   borderSide: .new(color: _darkColorScheme.outline),
    // ),

    // focusedBorder: OutlineInputBorder(
    //   borderRadius: .circular(AppRadius.r_14),
    //
    //   borderSide: .new(color: _darkColorScheme.primary, width: 1.5),
    // ),
  ),

  navigationBarTheme: NavigationBarThemeData(
    elevation: 0,

    backgroundColor: AppColors.darkSurface,

    indicatorColor: _darkColorScheme.secondaryContainer,

    labelBehavior: .alwaysShow,
  ),

  floatingActionButtonTheme: .new(
    elevation: 0,

    backgroundColor: _darkColorScheme.primary,

    foregroundColor: _darkColorScheme.onPrimary,

    shape: _fabShape,
  ),
);
