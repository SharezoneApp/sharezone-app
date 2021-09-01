import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/navigation/drawer/drawer.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';

import 'bottom_navigation_bar/bottom_navigation_bar.dart';
import 'bottom_navigation_bar/extendable_bottom_navigation_bar.dart';
import 'bottom_navigation_bar/navigation_experiment/navigation_experiment_cache.dart';
import 'bottom_navigation_bar/navigation_experiment/navigation_experiment_option.dart';

class PortableCustomScaffold extends StatelessWidget {
  final SliverAppBarConfiguration appBarConfiguration;
  final NavigationItem navigationItem;
  final Widget body;
  final Widget floatingActionButton;
  final Key scaffoldKey;

  const PortableCustomScaffold({
    @required this.navigationItem,
    @required this.appBarConfiguration,
    @required this.body,
    @required this.floatingActionButton,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final navigationCache = BlocProvider.of<NavigationExperimentCache>(context);
    return StreamBuilder<NavigationExperimentOption>(
      stream: navigationCache.currentNavigation,
      initialData: navigationCache.currentNavigation.valueOrNull,
      builder: (context, snapshot) {
        final option = snapshot.data ?? NavigationExperimentOption.drawerAndBnb;
        final isOldNav = option == NavigationExperimentOption.drawerAndBnb;
        return ExtendableBottomNavigationBar(
          currentNavigationItem: navigationItem,
          option: option,
          page: Scaffold(
            key: scaffoldKey,
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: appBarConfiguration.backgroundColor,
                  expandedHeight: appBarConfiguration.expandedHeight,
                  elevation: appBarConfiguration.elevation,
                  pinned: appBarConfiguration.pinned,
                  title: appBarConfiguration.title ?? navigationItem.getName(),
                  centerTitle: true,
                  leading: isOldNav
                      ? DrawerIcon(color: appBarConfiguration.drawerIconColor)
                      : null,
                  actions: appBarConfiguration.actions,
                  flexibleSpace: appBarConfiguration.flexibleSpace,
                ),
                SliverToBoxAdapter(child: body)
              ],
            ),
            floatingActionButton: floatingActionButton,
            drawer: isOldNav ? SharezoneDrawer() : null,
            bottomNavigationBar: isOldNav
                ? BnbAndDrawerBottomNavigationBar(
                    navigationItem: navigationItem)
                : null,
          ),
        );
      },
    );
  }
}
