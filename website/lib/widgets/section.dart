// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_website/home/home_page.dart';

import 'max_width_constraint_box.dart';

class Section extends StatelessWidget {
  const Section({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: maxWidthConstraint,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isPhone(context) ? 20 : 64),
        child: child,
      ),
    );
  }
}
