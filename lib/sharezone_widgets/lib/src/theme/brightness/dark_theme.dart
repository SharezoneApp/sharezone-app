// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of './general_theme.dart';

const _accentColor = Colors.lightBlue;

/// Returns the dark theme for the app.
///
/// In golden tests outside of `/app`, it's recommended to override [fontFamily]
/// to `Roboto` to because `golden_toolkit` can't load fonts of other packages.
ThemeData getDarkTheme({String? fontFamily = rubik}) {
  return ThemeData(
    // Brightness
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ElevationColors.dp0,

    // Colors
    primaryColor: primaryColor,
    unselectedWidgetColor: _accentColor,
    cardColor: ElevationColors.dp0,
    canvasColor: ElevationColors.dp2,
    highlightColor: PlatformCheck.isIOS ? Colors.grey[800] : null,
    splashColor: PlatformCheck.isIOS ? Colors.transparent : null,

    // Font:
    fontFamily: fontFamily,
    // Themes
    appBarTheme: const AppBarTheme(
      backgroundColor: ElevationColors.dp8,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _accentColor,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme().copyWith(
      headlineMedium: const TextStyle(color: Colors.white),
    ),
    pageTransitionsTheme: _pageTransitionsTheme,
    snackBarTheme: _snackBarTheme,
    bottomSheetTheme: _bottomSheetTheme,
    dialogTheme: _dialogTheme.copyWith(backgroundColor: ElevationColors.dp12),
    listTileTheme: ListTileThemeData(
      iconColor: const Color(0xFFC1C7CE),
      shape: listTileShape,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: inputDecorationTheme.copyWith(
      fillColor: ElevationColors.dp2,
      enabledBorder: inputDecorationTheme.enabledBorder?.copyWith(
        borderSide: inputDecorationTheme.enabledBorder?.borderSide.copyWith(
          color: ElevationColors.dp24,
        ),
      ),
    ),
    tabBarTheme: const TabBarThemeData(labelColor: Colors.white),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return _accentColor;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return _accentColor;
        }
        return null;
      }),
    ),
  );
}

extension ThemeExtension on ThemeData {
  bool get isDarkTheme => brightness == Brightness.dark;
}

/// Things with an elevation gets an other color.
/// Material Design published the Colors for
/// X dp elevation.
/// Link: https://material.io/design/color/dark-theme.html#properties
class ElevationColors {
  static const dp0 = Color(0xFF121212);
  static const dp1 = Color(0xFF1d1d1d);
  static const dp2 = Color(0xFF212121);
  static const dp3 = Color(0xFF242424);
  static const dp4 = Color(0xFF272727);
  static const dp6 = Color(0xFF2c2c2c);
  static const dp8 = Color(0xFF2d2d2d);
  static const dp12 = Color(0xFF333333);
  static const dp16 = Color(0xFF313131);
  static const dp24 = Color(0xFF363636);
}
