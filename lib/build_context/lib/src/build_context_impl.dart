// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

extension MediaQueryExt on BuildContext {
  Size get mediaQuerySize => MediaQuery.of(this).size;

  EdgeInsets get mediaQueryViewPadding => MediaQuery.of(this).viewPadding;

  double get textScaleFactor => MediaQuery.of(this).textScaleFactor;

  bool get isDesktopModus {
    if (mediaQuerySize.width < 700) {
      return false;
    } else if (mediaQuerySize.width >= 700 && mediaQuerySize.width <= 700) {
      if (mediaQuerySize.height > 500) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}

extension ThemeExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  Color get primaryColor => Theme.of(this).primaryColor;

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  bool get isDarkThemeEnabled => Theme.of(this).brightness == Brightness.dark;
}

extension ScaffoldExt on BuildContext {
  void hideCurrentSnackBar(
          {SnackBarClosedReason reason = SnackBarClosedReason.hide}) =>
      ScaffoldMessenger.of(this).hideCurrentSnackBar(reason: reason);
}
