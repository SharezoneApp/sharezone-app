// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_console/activation_codes/activation_codes_page.dart';
import 'package:sharezone_console/pages/change_type_of_user.dart';
import 'package:sharezone_console/pages/feedbacks/feedbacks_page.dart';

Future<void> openPage(BuildContext context, Widget widget) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sharezone Console"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: const Text("TypeOfUser ändern"),
            onTap: () {
              openPage(context, ChangeTypeOfUserPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: const Text("Aktivierungscodes"),
            onTap: () {
              openActivationCodesPage(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: const Text("Feedbacks"),
            onTap: () {
              openPage(context, FeedbacksPage());
            },
          ),
        ],
      ),
    );
  }
}
