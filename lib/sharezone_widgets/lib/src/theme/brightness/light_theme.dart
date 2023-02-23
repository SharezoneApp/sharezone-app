// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'general_theme.dart';

final lightTheme = ThemeData(
  // Brightness
  brightness: Brightness.light,

  // Colors
  cardColor: Colors.white,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.white,
  highlightColor: PlatformCheck.isIOS ? const Color(0x66BCBCBC) : null,
  splashColor: PlatformCheck.isIOS ? Colors.transparent : null,

  // Font
  fontFamily: rubik,

  // Theme
  tabBarTheme: TabBarTheme(
    labelColor: darkBlueColor,
    unselectedLabelColor: darkBlueColor.withOpacity(0.45),
  ),
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 1,
    iconTheme: IconThemeData(color: Color(0xFF8da2b6)),
    titleTextStyle: TextStyle(
        color: darkBlueColor,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        fontFamily: rubik),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
  pageTransitionsTheme: _pageTransitionsTheme,
  snackBarTheme: _snackBarTheme,
  bottomSheetTheme: _bottomSheetTheme,
  dialogTheme: _dialogTheme,
  checkboxTheme: CheckboxThemeData(
    fillColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return primaryColor;
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
        return primaryColor;
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
        return primaryColor;
      }
      return null;
    }),
    trackColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return primaryColor;
      }
      return null;
    }),
  ),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(secondary: Colors.grey[600], brightness: Brightness.light)
      .copyWith(error: Colors.red),
);
