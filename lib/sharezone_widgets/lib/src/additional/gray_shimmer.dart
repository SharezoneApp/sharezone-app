// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:shimmer/shimmer.dart';

class GrayShimmer extends StatelessWidget {
  const GrayShimmer({Key key, @required this.child, this.enabled = true})
      : super(key: key);

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkThemeEnabled(context);
    if (!enabled) return child;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800] : Colors.grey[300],
      highlightColor: isDark ? Colors.grey[600] : Colors.grey[100],
      child: child,
    );
  }
}
