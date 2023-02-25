// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:flutter/material.dart';

class Dimensions {
  final double height, width;

  const Dimensions(this.height, this.width);

  factory Dimensions.fromMediaQuery(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return Dimensions(mediaQueryData.size.height, mediaQueryData.size.width);
  }

  bool get isDesktopModus {
    if (width < 700) {
      return false;
    } else if (width >= 700 && width <= 700) {
      if (height > 500) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  EdgeInsets get dialogPaddingDimensions {
    if (isDesktopModus == false) {
      return EdgeInsets.zero;
    }

    return EdgeInsets.symmetric(
      horizontal: 32,
      vertical: _sizeByPixels(
        height,
        max: 64,
      ),
    );
  }

  double get dialogBorderRadiusDimensions {
    if (isDesktopModus == false) {
      return 0;
    } else {
      return 8;
    }
  }
}

double _sizeByPixels(
  double pixels, {
  required double max,
  double min = 0,
}) {
  final value = pow(100 * e, (pixels / 300) - 1);
  if (value < min) {
    return min;
  }
  if (value > max) {
    return max;
  }
  return value as double;
}
