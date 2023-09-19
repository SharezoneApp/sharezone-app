// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

// Widget to create a Svg
class SvgWidget extends StatelessWidget {
  const SvgWidget({
    super.key,
    required this.assetName,
    this.size = const Size.square(35.0),
    this.color,
  });

  final String assetName;
  final Size size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return PlatformSvg.asset(
      "$assetName.svg",
      width: size.width,
      height: size.height,
      color: color,
    );
  }
}
