// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_console/activation_codes/pages/new_activation_code_page.dart';
import 'package:sharezone_console/home_page.dart';

Future<void> openActivationCodesPage(BuildContext context) {
  return openPage(context, _ActivationCodesPage());
}

class _ActivationCodesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aktivierungscodes")),
      body: Center(child: Text("Diese Seite befindet sich noch im Aufbau!")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          openNewActivationPage(context);
        },
      ),
    );
  }
}
