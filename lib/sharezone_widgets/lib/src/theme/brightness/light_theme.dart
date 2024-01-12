// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'general_theme.dart';

const _errorCode = Colors.red;

/// Returns the light theme for the app.
///
/// In golden tests outside of `/app`, it's recommended to override [fontFamily]
/// to [roboto] to because `golden_toolkit` can't load fonts of other packages.
ThemeData getLightTheme({
  String? fontFamily = rubik,
}) {
  return ThemeData(
    // Brightness
    brightness: Brightness.light,

    // Colors
    cardColor: Colors.white,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    highlightColor: PlatformCheck.isIOS ? const Color(0x66BCBCBC) : null,
    splashColor: PlatformCheck.isIOS ? Colors.transparent : null,

    // Font
    fontFamily: fontFamily,

    // Theme
    tabBarTheme: TabBarTheme(
      labelColor: darkBlueColor,
      unselectedLabelColor: darkBlueColor.withOpacity(0.45),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF8da2b6)),
      titleTextStyle: TextStyle(
        color: darkBlueColor,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        fontFamily: fontFamily,
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(512),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.grey[700]!,
      shape: listTileShape,
      mouseCursor: MaterialStateMouseCursor.clickable,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: primaryColor,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: primaryColor,
      ),
    ),
    dialogBackgroundColor: Colors.white,
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5E5E5),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
    pageTransitionsTheme: _pageTransitionsTheme,
    snackBarTheme: _snackBarTheme.copyWith(
      backgroundColor: const Color(0xFF2B2525),
    ),
    inputDecorationTheme: inputDecorationTheme,
    bottomSheetTheme: _bottomSheetTheme,
    dialogTheme: _dialogTheme,
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
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
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
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
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return null;
      }),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.grey[600],
      brightness: Brightness.light,
      error: _errorCode,
    ),
  );
}
