import 'package:flutter/material.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';

class AppBarConfiguration {
  /// Default is [navigationItem.getName()]
  final String title;

  final List<Widget> actions;
  final PreferredSizeWidget bottom;
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
  final PreferredSizeWidget flexibleSpace;
  final double expandedHeight, elevation;
  final bool pinned;
  final Color backgroundColor;
  final Color drawerIconColor;

  const SliverAppBarConfiguration({
    @required this.actions,
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
  const _AppBarTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      NavigationItem.overview.getName(),
      style:
          Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
      key: const ValueKey('dashboard-appbar-title-E2E'),
    );
  }
}
