// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_utils/platform.dart';

import '../theme.dart';

part 'dark_theme.dart';
part 'light_theme.dart';

const blueColor = Color(0xFF68B3E9);
const darkBlueColor = Color(0xFF254D71);
// const _scaffoldBackground = Color(0xFFF6F7FB);
const greenColor = Color(0xFF2EF0C2);

const sharezoneBorderRadiusValue = 10.0;

const _roundedShape = RoundedRectangleBorder(
    borderRadius:
        BorderRadius.all(Radius.circular(sharezoneBorderRadiusValue)));

const _snackBarTheme = SnackBarThemeData(
  behavior: SnackBarBehavior.floating,
  actionTextColor: primaryColor,
);

const _pageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
  },
);

const _bottomSheetTheme = BottomSheetThemeData(
  clipBehavior: Clip.antiAlias,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(sharezoneBorderRadiusValue),
      topRight: Radius.circular(sharezoneBorderRadiusValue),
    ),
  ),
);

const _dialogTheme = DialogTheme(shape: _roundedShape);
