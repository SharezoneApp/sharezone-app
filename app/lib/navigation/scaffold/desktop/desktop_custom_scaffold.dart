// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/navigation/drawer/drawer.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/desktop/desktop_alignment.dart';

import '../app_bar_configuration.dart';

class DesktopCustomScaffold extends StatelessWidget {
  final SliverAppBarConfiguration appBarConfiguration;
  final NavigationItem navigationItem;
  final Widget body;
  final Widget floatingActionButton;
  final Key scaffoldKey;

  const DesktopCustomScaffold({
    @required this.navigationItem,
    @required this.appBarConfiguration,
    @required this.body,
    @required this.floatingActionButton,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return DesktopAlignment(
      drawer: SharezoneDrawer(isDesktopModus: true),
      scaffold: Scaffold(
        key: scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: appBarConfiguration.backgroundColor,
              expandedHeight: appBarConfiguration.expandedHeight,
              elevation: appBarConfiguration.elevation,
              pinned: appBarConfiguration.pinned,
              title: appBarConfiguration.title,
              centerTitle: true,
              actions: appBarConfiguration.actions,
              flexibleSpace: appBarConfiguration.flexibleSpace,
            ),
            SliverToBoxAdapter(child: body)
          ],
        ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
