import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemePlatform {
  // Material-Theme wird verwendet, wenn nicht Cupertino.
  static bool get isMaterial => !isCupertino;
  static bool get isCupertino =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
}

/// Gibt IconData abhängig von der ThemePlatform an. Standardmäßig das Material Icon
/// Sofern vorhanden, wird beim CupertinoTheme das cupertinoIcon angezeigt.
IconData themeIconData(IconData icon, {IconData cupertinoIcon}) {
  if (ThemePlatform.isMaterial) return icon;
  return cupertinoIcon ?? icon;
}
