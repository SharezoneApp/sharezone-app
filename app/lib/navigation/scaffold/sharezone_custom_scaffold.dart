// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'desktop/desktop_custom_scaffold.dart';
import 'portable/portable_custom_scaffold.dart';

class SharezoneCustomScaffold extends StatelessWidget {
  final SliverAppBarConfiguration appBarConfiguration;
  final NavigationItem navigationItem;
  final Widget body;
  final Widget floatingActionButton;
  final Key? scaffoldKey;

  const SharezoneCustomScaffold({
    super.key,
    required this.navigationItem,
    required this.body,
    required this.floatingActionButton,
    required this.appBarConfiguration,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions.fromMediaQuery(context);
    if (!dimensions.isDesktopModus) {
      return PortableCustomScaffold(
        scaffoldKey: scaffoldKey,
        navigationItem: navigationItem,
        appBarConfiguration: appBarConfiguration,
        body: body,
        floatingActionButton: floatingActionButton,
      );
    } else {
      return DesktopCustomScaffold(
        scaffoldKey: scaffoldKey,
        navigationItem: navigationItem,
        appBarConfiguration: appBarConfiguration,
        body: body,
        floatingActionButton: floatingActionButton,
      );
    }
  }
}
