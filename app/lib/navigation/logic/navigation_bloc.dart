// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';

class NavigationBloc extends BlocBase {
  final scaffoldKey = GlobalKey();
  final drawerKey = GlobalKey();
  final controllerKey = GlobalKey();

  final _navigationItemsSubject =
      BehaviorSubject<NavigationItem>.seeded(NavigationItem.overview);
  Stream<NavigationItem> get navigationItems => _navigationItemsSubject;

  NavigationItem get currentItem => _navigationItemsSubject.valueOrNull;

  Function(NavigationItem) get navigateTo => _navigationItemsSubject.sink.add;

  @override
  void dispose() {
    _navigationItemsSubject.close();
  }
}

Future<bool> popToOverview(BuildContext context) async {
  final navigationBloc = BlocProvider.of<NavigationBloc>(context);
  navigationBloc.navigateTo(NavigationItem.overview);
  return false;
}

Future<bool> popUntilOverview(BuildContext context) {
  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
  return null;
}
