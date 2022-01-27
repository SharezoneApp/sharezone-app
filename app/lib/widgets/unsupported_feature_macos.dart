// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/dialog_wrapper.dart';

void showUnsupportedFeatureDialog(BuildContext context) =>
    showDialog(context: context, builder: (context) => UnsupportedFeature());

class UnsupportedFeature extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Aktuell keine Unterstützung für macOS'),
      content: DialogWrapper(
        child: Text(
            "Momentan ist diese Funktion noch nicht für macOS verfügbar 😖"),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        )
      ],
    );
  }
}
