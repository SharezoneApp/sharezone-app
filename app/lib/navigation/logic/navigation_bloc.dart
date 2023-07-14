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

  void navigateTo(NavigationItem item) {
    // Sometimes in integration tests `navigateTo` is called after the bloc is
    // already disposed. In this case we want to do nothing.
    // This should probably be fixed in the integration tests, but for now we
    // use this workaround.
    if (_navigationItemsSubject.isClosed) {
      return;
    }
    _navigationItemsSubject.sink.add(item);
  }

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
