// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/navigation/analytics/navigation_analytics.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/theme.dart';

import '../drawer_controller.dart';

TextStyle getTextStyle(BuildContext context, bool isSelected) {
  Color color = isDarkThemeEnabled(context) ? Colors.white : Colors.black;
  if (isSelected) {
    color = isDarkThemeEnabled(context)
        ? Theme.of(context).primaryColor
        : darkBlueColor;
  }

  return TextStyle(
    fontWeight: FontWeight.w500,
    color: color,
    fontSize: 14,
  );
}

class DrawerTile extends StatelessWidget {
  /// Default is [navigationItem.getIcon()]
  final Widget icon;

  /// Default is [navigationItem.getName()]
  final String title;

  final String subtitle;

  /// Default is [navigationItem.getPageTag()]
  final String tag;

  final Widget trailing;

  final NavigationItem navigationItem;

  const DrawerTile(
    this.navigationItem, {
    Key key,
    this.title,
    this.icon,
    this.trailing,
    this.tag,
    this.subtitle,
  })  : assert(navigationItem != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    final title = this.title ?? navigationItem.getName();
    final icon = this.icon ?? navigationItem.getIcon();
    final tag = this.tag ?? navigationItem.getPageTag();

    return StreamBuilder<NavigationItem>(
        key: ValueKey('nav-item-${navigationItem.name}-E2E'),
        stream: navigationBloc.navigationItems,
        builder: (context, snapshot) {
          final currentNavigationItem = snapshot.data;

          bool isSelected = false;
          if (currentNavigationItem != null)
            isSelected = currentNavigationItem == navigationItem;

          Widget child;

          if (isSelected) {
            child = _SelectedDrawerTile(
              title: title,
              subtitle: subtitle,
              icon: icon,
              trailing: trailing,
              onTap: () => _onTap(context),
            );
          } else {
            child = _DefaultDrawerTile(
              title: title,
              subtitle: subtitle,
              icon: icon,
              trailing: trailing,
              onTap: () => _onTap(context),
            );
          }

          return child;

          // A Flutter regression results in the `AnimatedSwitcher` causing
          // errors in the Flutter rendering code when changing pages in desktop
          // mode via the permanent drawer.
          //
          // The code below can be reintroduced when the following bug is fixed:
          // https://github.com/flutter/flutter/issues/120874

          // final dimensions = Dimensions.fromMediaQuery(context);
          // if (!dimensions.isDesktopModus) return child;
          //
          //
          // return AnimatedSwitcher(
          //   duration: const Duration(milliseconds: 300),
          //   key: ValueKey(tag),
          //   child: child,
          // );
        });
  }

  void _onTap(BuildContext context) {
    final tag = this.tag ?? navigationItem.getPageTag();
    if (navigationItem != null) {
      final navigationController = BlocProvider.of<NavigationBloc>(context);
      navigationController.navigateTo(navigationItem);
    } else {
      final drawerController =
          BlocProvider.of<SharezoneDrawerController>(context);
      if (!drawerController.isDesktopModus) Navigator.pop(context);
      Navigator.pushNamed(context, tag);
      _logDrawerTileClick(context);
    }
  }

  void _logDrawerTileClick(BuildContext context) {
    final analytics = BlocProvider.of<NavigationAnalytics>(context);
    analytics.logDrawerEvent(navigationItem);
  }
}

class _SelectedDrawerTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const _SelectedDrawerTile({
    Key key,
    this.icon,
    this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).primaryColor.withOpacity(0.15),
        child: ListTile(
          leading: IconTheme(
            data: context.theme.iconTheme.copyWith(
              color: isDarkThemeEnabled(context)
                  ? Theme.of(context).primaryColor
                  : darkBlueColor,
            ),
            child: icon,
          ),
          title: Text(title, style: getTextStyle(context, true)),
          subtitle: isNotEmptyOrNull(subtitle) ? Text(subtitle) : null,
          enabled: false,
          onTap: onTap,
          trailing: trailing,
        ),
      ),
    );
  }
}

class _DefaultDrawerTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const _DefaultDrawerTile({
    Key key,
    this.icon,
    this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: icon,
          title: Text(title, style: getTextStyle(context, false)),
          subtitle: isNotEmptyOrNull(subtitle) ? Text(subtitle) : null,
          enabled: true,
          onTap: onTap,
          trailing: trailing,
        ),
      ),
    );
  }
}
