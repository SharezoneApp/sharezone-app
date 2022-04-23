// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/account/features/features_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'drawer_tile.dart';

const settingsPageTile = DrawerTile(NavigationItem.settings);
const feedbackBoxtile = DrawerTile(NavigationItem.feedbackBox);
final donatePageTile = Builder(
  builder: (context) => StreamBuilder<bool>(
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
