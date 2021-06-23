import 'package:flutter/material.dart';
import 'package:sharezone_widgets/theme.dart';

const rubik = 'Rubik';

const Color accentColor = Colors.redAccent;
const Color primaryColor = Color(0xFF68B3E9);

Size getScreenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

Future<void> delayKeyboard(
    {@required BuildContext context,
    @required FocusNode focusNode,
    Duration duration = const Duration(milliseconds: 250)}) async {
  await Future.delayed(duration);
  FocusScope.of(context).requestFocus(focusNode);
}

Future<void> hideKeyboardWithDelay(
    {@required BuildContext context,
    Duration duration = const Duration(milliseconds: 250)}) async {
  await Future.delayed(duration);
  FocusScope.of(context).requestFocus(FocusNode());
}

void hideKeyboard(
    {@required BuildContext context,
    Duration duration = const Duration(milliseconds: 250)}) {
  FocusScope.of(context).requestFocus(FocusNode());
}

const double cardElevation = 1.5; // Elevation of Cards

TextStyle flowingText = TextStyle(
  textBaseline: TextBaseline.alphabetic,
  fontSize: 15.0,
  height: 24.0 / 15.0,
  fontFamily: rubik,
);

TextStyle linkStyle(BuildContext context, [double fontSize]) => TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.underline,
      fontFamily: rubik,
      height: 1.05,
      fontSize: fontSize ?? 16.0,
    );

class Headline extends StatelessWidget {
  const Headline(this.title, {this.textAlign});

  final String title;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color:
              isDarkThemeEnabled(context) ? Colors.grey[400] : Colors.grey[700],
          fontWeight: FontWeight.w600,
        ),
        textAlign: textAlign,
      ),
    );
  }
}

// Blau Titel - Unterteilen die Seite in Kategorien
class CategoryTitle extends StatelessWidget {
  const CategoryTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
