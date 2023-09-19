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
import 'package:sharezone_utils/dimensions.dart';

import 'bottom_bar_configuration.dart';
import 'desktop/desktop_main_scaffold.dart';
import 'portable/portable_main_scaffold.dart';

class SharezoneMainScaffold extends StatelessWidget {
  final AppBarConfiguration? appBarConfiguration;
  final NavigationItem navigationItem;
  final Widget body;
  final Widget? floatingActionButton;
  final BottomBarConfiguration? bottomBarConfiguration;
  final Key? scaffoldKey;
  final Color? colorBehindBNB;

  const SharezoneMainScaffold({
    super.key,
    required this.navigationItem,
    required this.body,
    this.appBarConfiguration,
    this.floatingActionButton,
    this.bottomBarConfiguration,
    this.scaffoldKey,
    this.colorBehindBNB,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions.fromMediaQuery(context);
    if (!dimensions.isDesktopModus) {
      return PortableMainScaffold(
        scaffoldKey: scaffoldKey,
        navigationItem: navigationItem,
        appBarConfiguration: appBarConfiguration,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomBarConfiguration: bottomBarConfiguration,
        colorBehindBNB: colorBehindBNB,
      );
    } else {
      return DesktopMainScaffold(
        scaffoldKey: scaffoldKey,
        navigationItem: navigationItem,
        appBarConfiguration: appBarConfiguration,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomBarConfiguration: bottomBarConfiguration,
      );
    }
  }
}
