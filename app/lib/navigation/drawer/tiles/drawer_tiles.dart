// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'drawer_tile.dart';

const settingsPageTile = DrawerTile(NavigationItem.settings);
const feedbackBoxTile = DrawerTile(NavigationItem.feedbackBox);
const sharezonePlusTile = DrawerTile(NavigationItem.sharezonePlus);
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
