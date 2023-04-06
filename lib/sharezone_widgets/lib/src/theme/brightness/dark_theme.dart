// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of './general_theme.dart';

const _accentColor = Colors.lightBlue;

final darkTheme = ThemeData(
  // Brightness
  brightness: Brightness.dark,
  scaffoldBackgroundColor: ElevationColors.dp0,

  // Colors
  primaryColor: primaryColor,
  unselectedWidgetColor: _accentColor,
  cardColor: ElevationColors.dp0,
  indicatorColor: Colors.amberAccent,
  dialogBackgroundColor: ElevationColors.dp12,
  canvasColor: ElevationColors.dp2,
  highlightColor: PlatformCheck.isIOS ? Colors.grey[800] : null,
  splashColor: PlatformCheck.isIOS ? Colors.transparent : null,

  // Font:
  fontFamily: rubik,

  // Themes
  appBarTheme: const AppBarTheme(
    color: ElevationColors.dp8,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _accentColor,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme()
      .copyWith(headlineMedium: const TextStyle(color: Colors.white)),
  pageTransitionsTheme: _pageTransitionsTheme,
  snackBarTheme: _snackBarTheme.copyWith(
    contentTextStyle: const TextStyle(
      color: Colors.white,
    ),
  ),
  bottomSheetTheme: _bottomSheetTheme,
  dialogTheme: _dialogTheme,
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(secondary: _accentColor, brightness: Brightness.dark),
  tabBarTheme: const TabBarTheme(labelColor: Colors.white),
  checkboxTheme: CheckboxThemeData(
    fillColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return _accentColor;
      }
      return null;
    }),
  ),
  radioTheme: RadioThemeData(
    fillColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return _accentColor;
      }
      return null;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return _accentColor;
      }
      return null;
    }),
    trackColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return _accentColor;
      }
      return null;
    }),
  ),
);

bool isDarkThemeEnabled(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

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
