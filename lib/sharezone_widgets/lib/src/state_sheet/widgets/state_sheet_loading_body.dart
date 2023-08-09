// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class StateSheetLoadingBody extends StatelessWidget {
  const StateSheetLoadingBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: const [
        SizedBox(height: 32),
        SizedBox(
          width: 35,
          height: 35,
          child: AccentColorCircularProgressIndicator(),
        ),
        SizedBox(height: 16),
        Text(
          "Daten werden verschlüsselt übertragen...",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
