// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class ExpandedChip extends StatelessWidget {
  final Color color;
  final String text;
  final double fontSize;
  final TextAlign? textAlign;

  const ExpandedChip({
    super.key,
    this.color = Colors.orange,
    required this.text,
    this.fontSize = 18,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.orange, fontSize: fontSize),
        textAlign: textAlign,
      ),
    );
  }
}
