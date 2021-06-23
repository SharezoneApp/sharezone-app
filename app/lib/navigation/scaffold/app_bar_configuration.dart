import 'package:flutter/material.dart';

class AppBarConfiguration {
  /// Default is [navigationItem.getName()]
  final String title;

  final List<Widget> actions;
  final Widget bottom;
  final double elevation;

  const AppBarConfiguration({
    this.title,
    this.actions = const [],
    this.bottom,
    this.elevation = 1,
  });
}

class SliverAppBarConfiguration {
  /// Default is [navigationItem.getName()]
  final Widget title;
  
  final List<Widget> actions;
  final PreferredSizeWidget flexibleSpace;
  final double expandedHeight, elevation;
  final bool pinned;
  final Color backgroundColor;
  final Color drawerIconColor;

  const SliverAppBarConfiguration({
    @required this.actions,
    this.title,
    this.flexibleSpace,
    this.expandedHeight,
    this.backgroundColor,
    this.elevation = 1,
    this.pinned,
    this.drawerIconColor,
  });
}
