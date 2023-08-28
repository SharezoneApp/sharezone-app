// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Displays a [Banner] saying "ALPHA" when running an alpha version at top left
/// hand corner.
///
/// Displays nothing when [enabled] is false.
///
/// This widget is similar and inspired by the [CheckedModeBanner] which displays
/// "DEBUG" at the top right hand corner when running a Flutter app in debug
/// mode.
class AlphaVersionBanner extends StatelessWidget {
  /// Creates a const alpha version banner.
  const AlphaVersionBanner({
    Key? key,
    required this.child,
    required this.enabled,
  }) : super(key: key);

  /// The widget to show behind the banner.
  final Widget child;

  /// Defines if the alpha banner should shown.
  ///
  /// If set to false, the banner will not be shown and is not visible.
  final bool enabled;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    String message = 'disabled';
    if (enabled) {
      message = 'ALPHA';
    }
    properties.add(DiagnosticsNode.message(message));
  }

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return Banner(
      message: 'ALPHA',
      textDirection: TextDirection.ltr,
      location: BannerLocation.topEnd,
      color: Colors.blue,
      child: child,
    );
  }
}
