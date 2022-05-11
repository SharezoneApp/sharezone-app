// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Displays a [Banner] saying "ALPHA" when running an alpha version at top left
/// hand corner.
///
/// Does nothing when running a beta or stable version.
///
/// To be able to detect if this app is running an alpha version, set is it
/// required to set the environment variable "ALPHA" set to true (like `flutter
/// run --dart-define ALPHA=true`).
///
/// This widget is similar and inspired by the [CheckedModeBanner] which display
/// "DEBUG" at the top right hand corner when running a Flutter app in debug
/// mode.
class AlphaVersionBanner extends StatelessWidget {
  /// Creates a const alpha version banner.
  const AlphaVersionBanner({
    Key key,
    @required this.child,
    this.isAlphaVersion = const bool.fromEnvironment('ALPHA'),
  }) : super(key: key);

  /// The widget to show behind the banner.
  final Widget child;

  /// Defines if the app is running an alpha version.
  final bool isAlphaVersion;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    String message = 'disabled';
    if (isAlphaVersion) {
      message = 'ALPHA';
    }
    properties.add(DiagnosticsNode.message(message));
  }

  @override
  Widget build(BuildContext context) {
    Widget result = child;
    if (isAlphaVersion) {
      result = Banner(
        message: 'ALPHA',
        textDirection: TextDirection.ltr,
        location: BannerLocation.topEnd,
        child: result,
      );
    }
    return result;
  }
}
