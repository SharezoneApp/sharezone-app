// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
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
                    TextSpan(text: context.l10n.groupsContactSupportPrefix),
                    TextSpan(
                      text: context.l10n.groupsContactSupportLinkText,
                      style: linkStyle(context),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap =
                                () => Navigator.pushNamed(
                                  context,
                                  SupportPage.tag,
                                ),
                    ),
                    TextSpan(text: context.l10n.groupsContactSupportSuffix),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
