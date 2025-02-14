// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:design/design.dart';
import 'package:flutter/material.dart';

class SubjectAvatar extends StatelessWidget {
  const SubjectAvatar({
    super.key,
    required this.design,
    required this.abbreviation,
  });

  final String abbreviation;
  final Design design;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: design.color.withValues(alpha: 0.2),
      child: Text(
        abbreviation,
        style: TextStyle(color: design.color),
      ),
    );
  }
}
