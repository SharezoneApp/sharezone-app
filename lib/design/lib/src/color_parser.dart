// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:color/color.dart' as colorlib;
import 'package:flutter/material.dart';

class ColorParser {
  static String toHex(Color color) {
    final rgbColor = colorlib.RgbColor(color.red, color.green, color.blue);
    return rgbColor.toHexColor().toString();
  }

  static Color fromHex(String? hex) {
    if (hex == null) return Colors.blue;
    final rgbColor = colorlib.HexColor(hex).toRgbColor();
    return Color.fromARGB(
        255, rgbColor.r as int, rgbColor.g as int, rgbColor.b as int);
  }
}
