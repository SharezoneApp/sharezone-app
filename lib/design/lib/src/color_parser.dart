import 'package:color/color.dart' as colorlib;
import 'package:flutter/material.dart';

class ColorParser {
  static String toHex(Color color) {
    final rgbColor = colorlib.RgbColor(color.red, color.green, color.blue);
    return rgbColor.toHexColor().toString();
  }

  static Color fromHex(String hex) {
    if (hex == null) return Colors.blue;
    final rgbColor = colorlib.HexColor(hex).toRgbColor();
    return Color.fromARGB(255, rgbColor.r, rgbColor.g, rgbColor.b);
  }
}
