// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class StateSheetSimpleBody extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color iconColor;
  final String description;

  const StateSheetSimpleBody({
    Key key,
    this.title,
    this.iconData,
    this.iconColor,
    this.description,
  }) : super(key: key);

  StateSheetSimpleBody.fromSimpleData({
    Key key,
    SimpleData simpleData,
  })  : title = simpleData.title,
        iconData = simpleData.iconData,
        iconColor = simpleData.iconColor,
        description = simpleData.description,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 16),
        Icon(iconData, size: 56, color: iconColor),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        if (description != null) Text(description, textAlign: TextAlign.center),
      ],
    );
  }
}
