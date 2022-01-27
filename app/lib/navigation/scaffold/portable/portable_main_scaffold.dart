// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/navigation/drawer/drawer.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_cache.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../bottom_bar_configuration.dart';
import 'bottom_navigation_bar/bottom_navigation_bar.dart';
import 'bottom_navigation_bar/extendable_bottom_navigation_bar.dart';
import 'bottom_navigation_bar/navigation_experiment/navigation_experiment_option.dart';

class PortableMainScaffold extends StatefulWidget {
  final AppBarConfiguration appBarConfiguration;
  final NavigationItem navigationItem;
  final Widget body;
  final Widget floatingActionButton;
  final BottomBarConfiguration bottomBarConfiguration;
  final Key scaffoldKey;

  /// Through the round corners of the [ExtendableBottomNavigationBar] you can
  /// look behind the [ExtendableBottomNavigationBar]. With [colorBehindBNB] you
  /// set this color.
  ///
  /// Default is [context.scaffoldBackgroundColor]
  final Color colorBehindBNB;

  const PortableMainScaffold({
    @required this.navigationItem,
    @required this.appBarConfiguration,
    @required this.body,
    @required this.floatingActionButton,
    this.bottomBarConfiguration,
    this.scaffoldKey,
    this.colorBehindBNB,
  });

  @override
  _PortableMainScaffoldState createState() => _PortableMainScaffoldState();
}

class _PortableMainScaffoldState extends State<PortableMainScaffold> {
  PanelController controller = PanelController();

  @override
  Widget build(BuildContext context) {
    final navigationCache = BlocProvider.of<NavigationExperimentCache>(context);
    return StreamBuilder<NavigationExperimentOption>(
      stream: navigationCache.currentNavigation,
      initialData: navigationCache.currentNavigation.valueOrNull,
      builder: (context, snapshot) {
        final option = snapshot.data ?? NavigationExperimentOption.drawerAndBnb;
        final isOldNav = option == NavigationExperimentOption.drawerAndBnb;
        return AnimatedSwitcher(
          duration: Duration(seconds: 1),
          child: ExtendableBottomNavigationBar(
            currentNavigationItem: widget.navigationItem,
            colorBehindBNB: widget.colorBehindBNB,
            option: option,
            page: Scaffold(
              key: widget.scaffoldKey,
              drawer: isOldNav ? SharezoneDrawer() : null,
              appBar: AppBar(
                title: Text(widget.appBarConfiguration?.title ??
                    widget.navigationItem.getName()),
                centerTitle: isOldNav,
                elevation: widget.appBarConfiguration?.elevation,
                leading: isOldNav ? DrawerIcon() : null,
                automaticallyImplyLeading: isOldNav,
                bottom: widget.appBarConfiguration?.bottom,
                actions: widget.appBarConfiguration?.actions,
              ),
              bottomNavigationBar: bottomBar(option),
              body: widget.body,
              floatingActionButton: widget.floatingActionButton,
            ),
          ),
        );
      },
    );
  }

  Widget bottomBar(NavigationExperimentOption option) {
    if (option != NavigationExperimentOption.drawerAndBnb)
      return widget.bottomBarConfiguration?.bottomBar;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.bottomBarConfiguration?.bottomBar != null)
          widget.bottomBarConfiguration.bottomBar,
        BnbAndDrawerBottomNavigationBar(navigationItem: widget.navigationItem),
      ],
    );
  }
}
