// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_website/main.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText(
      {super.key, required this.text, this.fontSize = 14, this.textStyle});

  final Widget text;
  final double fontSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(width: 200),
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Divider(height: 0),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: fontSize,
                    fontFamily: SharezoneStyle.font,
                  ),
                  child: text,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
