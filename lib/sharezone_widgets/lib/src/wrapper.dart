// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class MaxWidthConstraintBox extends StatelessWidget {
  const MaxWidthConstraintBox({
    Key? key,
    required this.child,
    this.maxWidth = 1000,
  }) : super(key: key);

  final Widget child;

  /// The maximum width that satisfies the constraints.
  ///
  /// Default is 1000
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
