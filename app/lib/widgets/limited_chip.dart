// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class LimitedChip extends StatelessWidget {
  const LimitedChip({
    super.key,
    this.backgroundColor,
    this.foregroundColor,
  });

  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(7.5),
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(8, 4, 10, 4),
        child: Text('LIMITED'),
      ),
    );
  }
}
