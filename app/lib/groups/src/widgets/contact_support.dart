// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/pages/settings/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ContactSupport extends StatelessWidget {
  const ContactSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Divider(height: 0),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                  children: <TextSpan>[
                    const TextSpan(
                        text:
                            "Du brauchst Hilfe? Dann kontaktiere einfach unseren "),
                    TextSpan(
                        text: "Support",
                        style: linkStyle(context),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              Navigator.pushNamed(context, SupportPage.tag)),
                    const TextSpan(text: " 😉"),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
