// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sharezone/dynamic_links/einkommender_link.dart';

class DynamicLinkOverlay extends StatelessWidget {
  final Stream<EinkommenderLink> einkommendeLinks;
  final bool activated;
  final Widget child;

  const DynamicLinkOverlay(
      {Key key, this.einkommendeLinks, this.activated, this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EinkommenderLink>(
      stream: einkommendeLinks,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.data.empty && activated) {
          final einkommenderLink = snapshot.data;
          // If Notification is shown directly an Error as thrown, as it can't be displayed while this is still bulding (marked as dirty)
          Future.delayed(Duration(seconds: 1)).then((_) =>
              showSimpleNotification(
                  Text("Neuer dynamic Link: \n$einkommenderLink"),
                  autoDismiss: false,
                  slideDismissDirection: DismissDirection.horizontal,
                  leading: Icon(Icons.link)));
        }
        return child;
      },
    );
  }
}
