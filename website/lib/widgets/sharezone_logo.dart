// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum LogoColor {
  white,
  blueLong,
  blueShort,
}

class SharezoneLogo extends StatelessWidget {
  const SharezoneLogo({
    super.key,
    required this.logoColor,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;
  final LogoColor logoColor;

  String getLogoPath() {
    switch (logoColor) {
      case LogoColor.blueLong:
        return "assets/logo/sharezone-logo-blue-long.svg";
      case LogoColor.blueShort:
        return "assets/logo/sharezone-logo-blue-short.svg";
      case LogoColor.white:
        return "assets/logo/sharezone-logo-white-long.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Sharezone logo',
      button: true,
      onTapHint: 'Return to home page',
      child: Hero(
        tag: 'sharezone-logo-$logoColor',
        child: SvgPicture.asset(
          getLogoPath(),
          height: height,
          width: width,
        ),
      ),
    );
  }
}
