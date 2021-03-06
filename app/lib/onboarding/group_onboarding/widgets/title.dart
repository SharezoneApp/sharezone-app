// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_common/helper_functions.dart';

class GroupOnboardingTitle extends StatelessWidget {
  GroupOnboardingTitle(this.title, {Key key})
      : assert(isNotEmptyOrNull(title)),
        super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 22),
    );
  }
}
