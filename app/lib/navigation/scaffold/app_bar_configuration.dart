// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/keys.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';

class AppBarConfiguration {
  /// Default is [navigationItem.getName()]
  final String? title;

  final List<Widget> actions;
  final PreferredSizeWidget? bottom;
  final double elevation;

  const AppBarConfiguration({
    this.title,
    this.actions = const [],
    this.bottom,
    this.elevation = 1,
  });
}

class SliverAppBarConfiguration {
  /// Default is [_AppBarTitle]
  final Widget title;

  final List<Widget> actions;
  final PreferredSizeWidget? flexibleSpace;
  final double? expandedHeight;
  final double elevation;
  final bool? pinned;
  final Color? backgroundColor;
  final Color? drawerIconColor;

  const SliverAppBarConfiguration({
    required this.actions,
    this.title = const _AppBarTitle(),
    this.flexibleSpace,
    this.expandedHeight,
    this.backgroundColor,
    this.elevation = 1,
    this.pinned,
    this.drawerIconColor,
  });
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      NavigationItem.overview.getName(),
      style:
          Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
      key: K.dashboardAppBarTitle,
    );
  }
}
