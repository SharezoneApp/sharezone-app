import 'package:flutter/material.dart';

import 'svg.dart';

enum LogoColor {
  white,
  blue_long,
  blue_short,
}

class SharezoneLogo extends StatelessWidget {
  const SharezoneLogo({
    Key key,
    @required this.logoColor,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;
  final LogoColor logoColor;

  String getLogoPath() {
    switch (logoColor) {
      case LogoColor.blue_long:
        return "assets/logo/sharezone-logo-blue-long.svg";
      case LogoColor.blue_short:
        return "assets/logo/sharezone-logo-blue-short.svg";
      case LogoColor.white:
        return "assets/logo/sharezone-logo-white-long.svg";
    }
    return null;
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
        child: PlatformSvg.asset(
          getLogoPath(),
          height: height,
          width: width,
        ),
      ),
    );
  }
}
