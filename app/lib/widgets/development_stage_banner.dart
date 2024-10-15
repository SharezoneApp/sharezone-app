// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/main/constants.dart';

/// Displays the current development stage as a [Banner] if it is not stable.
///
/// Sharezone has different development stages e.g. "alpha", "beta", "preview".
/// This widget displays the current development stage as a [Banner] at the top
/// hand corner of the screen if we are not in the stable/production development
/// stage.
///
/// This is intended so that users know that they are using a non-stable version
/// of the app and that they should expect bugs and other issues.
///
/// This widget is similar and inspired by the [CheckedModeBanner] which displays
/// "DEBUG" at the top right hand corner when running a Flutter app in debug
/// mode.
class DevelopmentStageBanner extends StatelessWidget {
  /// Creates a const alpha version banner.
  const DevelopmentStageBanner({
    super.key,
    required this.child,
  });

  /// The widget to show behind the banner.
  final Widget child;

  bool get _isStable =>
      kDevelopmentStageOrNull == null || _uppercasedStage == 'STABLE';
  String? get _uppercasedStage => kDevelopmentStageOrNull?.toUpperCase();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    String message = 'disabled';
    if (!_isStable) {
      message = _uppercasedStage!;
    }
    properties.add(DiagnosticsNode.message(message));
  }

  @override
  Widget build(BuildContext context) {
    if (_isStable) {
      return child;
    }

    return Banner(
      message: _uppercasedStage!,
      textDirection: TextDirection.ltr,
      location: BannerLocation.topEnd,
      color: Colors.blue,
      child: child,
    );
  }
}
