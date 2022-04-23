// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlatformSvg {
  static Widget asset(
    String assetName, {
    double width,
    double height,
    BoxFit fit = BoxFit.contain,
    Color color,
    alignment = Alignment.center,
    String semanticsLabel,
  }) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
      color: color,
      alignment: alignment,
      semanticsLabel: semanticsLabel,
    );
  }

  static Widget network(
    String url, {
    double width,
    double height,
    BoxFit fit = BoxFit.contain,
    Color color,
    alignment = Alignment.center,
    String semanticsLabel,
  }) {
    return SvgPicture.network(
      url,
      width: width,
      height: height,
      fit: fit,
      color: color,
      alignment: alignment,
      semanticsLabel: semanticsLabel,
    );
  }
}
