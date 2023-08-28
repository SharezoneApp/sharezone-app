// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:flutter/material.dart';
import 'package:sharezone/navigation/drawer/drawer.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/desktop/desktop_alignment.dart';

import '../app_bar_configuration.dart';
import '../bottom_bar_configuration.dart';

class DesktopMainScaffold extends StatelessWidget {
  final AppBarConfiguration? appBarConfiguration;
  final NavigationItem navigationItem;
  final Widget body;
  final Widget? floatingActionButton;
  final BottomBarConfiguration? bottomBarConfiguration;
  final Key? scaffoldKey;

  const DesktopMainScaffold({
    required this.navigationItem,
    required this.appBarConfiguration,
    required this.body,
    required this.floatingActionButton,
    this.bottomBarConfiguration,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return DesktopAlignment(
      drawer: SharezoneDrawer(isDesktopModus: true),
      scaffold: ScaffoldMessenger(
        key: scaffoldKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarConfiguration?.title ?? navigationItem.getName()),
            centerTitle: true,
            actions: appBarConfiguration?.actions,
            bottom: appBarConfiguration?.bottom,
            elevation: appBarConfiguration?.elevation,
          ),
          body: body,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomBarConfiguration?.bottomBar,
        ),
      ),
    );
  }
}
