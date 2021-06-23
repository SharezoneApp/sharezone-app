import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/account/features/features_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'drawer_tile.dart';

const settingsPageTile = DrawerTile(NavigationItem.settings);
const feedbackBoxtile = DrawerTile(NavigationItem.feedbackBox);
final donatePageTile = Builder(
  builder: (context) => StreamBuilder(
    stream: BlocProvider.of<FeatureBloc>(context).hideDonations,
    builder: (context, snapshot) {
      final hideDonations = snapshot.data ?? false;
      if (hideDonations) return Container();
      return DrawerTile(NavigationItem.donate);
    },
  ),
);
const onlyDesktopTiles = <Widget>[
  DrawerTile(NavigationItem.overview),
  DrawerTile(NavigationItem.group),
  DrawerTile(NavigationItem.homework),
  DrawerTile(NavigationItem.timetable),
  DrawerTile(NavigationItem.blackboard),
];

const functionTiles = <Widget>[
  DrawerTile(NavigationItem.filesharing),
  DrawerTile(NavigationItem.events),
];
