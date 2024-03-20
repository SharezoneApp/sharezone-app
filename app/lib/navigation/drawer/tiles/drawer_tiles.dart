// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/navigation/drawer/tiles/feedback_drawer_tile.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'drawer_tile.dart';

const settingsPageTile = DrawerTile(NavigationItem.settings);
const feedbackBoxTile = FeedbackDrawerTile();
const sharezonePlusTile = DrawerTile(NavigationItem.sharezonePlus);
const gradesTile = DrawerTile(NavigationItem.grades);
const onlyDesktopTiles = <Widget>[
  DrawerTile(NavigationItem.overview),
  DrawerTile(NavigationItem.group),
  DrawerTile(NavigationItem.homework),
  DrawerTile(NavigationItem.timetable),
  DrawerTile(NavigationItem.blackboard),
  DrawerTile(NavigationItem.grades),
];

const functionTiles = <Widget>[
  DrawerTile(NavigationItem.filesharing),
  DrawerTile(NavigationItem.events),
];
