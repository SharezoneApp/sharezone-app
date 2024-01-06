// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

/// The default font family used in the app.
const rubik = 'Rubik';

/// The font family that is used for golden tests outside of `/app`.
///
/// We can't use [rubik] because `golden_toolkit` can't load fonts of other
/// packages, see https://github.com/eBay/flutter_glove_box/issues/158.
const roboto = 'Roboto';

const Color accentColor = Colors.redAccent;
const Color primaryColor = Color(0xFF68B3E9);
const Color darkPrimaryColor = Color(0xFF254D71);

Size getScreenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

Future<void> delayKeyboard(
    {required BuildContext context,
    required FocusNode focusNode,
    Duration duration = const Duration(milliseconds: 250)}) async {
  await Future.delayed(duration);
  focusNode.requestFocus();
}

Future<void> hideKeyboardWithDelay(
    {required BuildContext context,
    Duration duration = const Duration(milliseconds: 250)}) async {
  await Future.delayed(duration);
  FocusManager.instance.primaryFocus?.unfocus();
}

void hideKeyboard(
    {required BuildContext context,
    Duration duration = const Duration(milliseconds: 250)}) {
  FocusManager.instance.primaryFocus?.unfocus();
}

const double cardElevation = 1.5; // Elevation of Cards

TextStyle flowingText = const TextStyle(
  textBaseline: TextBaseline.alphabetic,
  fontSize: 15.0,
  height: 24.0 / 15.0,
  fontFamily: rubik,
);

TextStyle linkStyle(BuildContext context, [double? fontSize]) => TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.underline,
      fontFamily: rubik,
      height: 1.05,
      fontSize: fontSize ?? 16.0,
    );

class Headline extends StatelessWidget {
  const Headline(this.title, {super.key, this.textAlign});

  final String title;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).isDarkTheme
              ? Colors.grey[400]
              : Colors.grey[700],
          fontWeight: FontWeight.w600,
        ),
        textAlign: textAlign,
      ),
    );
  }
}

// Blau Titel - Unterteilen die Seite in Kategorien
class CategoryTitle extends StatelessWidget {
  const CategoryTitle(this.title, {super.key});

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
