// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
IconData themeIconData(IconData icon, {IconData? cupertinoIcon}) {
  if (ThemePlatform.isMaterial) return icon;
  return cupertinoIcon ?? icon;
}
