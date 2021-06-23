part of 'general_theme.dart';

final lightTheme = ThemeData(
  // Brightness
  brightness: Brightness.light,
  primaryColorBrightness: Brightness.light,
  accentColorBrightness: Brightness.light,

  // Colors
  cardColor: Colors.white,
  primaryColor: primaryColor,
  accentColor: Colors.grey[600],
  scaffoldBackgroundColor: Colors.white,
  highlightColor: PlatformCheck.isIOS ? const Color(0x66BCBCBC) : null,
  splashColor: PlatformCheck.isIOS ? Colors.transparent : null,
  toggleableActiveColor: primaryColor,
  errorColor: Colors.red,

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
    textTheme: TextTheme(
      headline6: TextStyle(
          color: darkBlueColor,
          fontWeight: FontWeight.w600,
          fontSize: 20,
          fontFamily: rubik),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
  pageTransitionsTheme: _pageTransitionsTheme,
  snackBarTheme: _snackBarTheme,
  bottomSheetTheme: _bottomSheetTheme,
  dialogTheme: _dialogTheme,
);
