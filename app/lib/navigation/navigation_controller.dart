// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/notifications/firebase_messaging_callback_configurator.dart';

import 'models/navigation_item.dart';

class NavigationController extends StatefulWidget {
  const NavigationController({
    Key key,
    @required this.fbMessagingConfigurator,
  }) : super(key: key);

  final FirebaseMessagingCallbackConfigurator fbMessagingConfigurator;
  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  @override
  void initState() {
    widget.fbMessagingConfigurator.configureCallbacks(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);
    return StreamBuilder<NavigationItem>(
      stream: navigationBloc.navigationItems,
      builder: (context, snapshot) {
        final currentNavigationItem = snapshot.data ?? NavigationItem.overview;
        return currentNavigationItem.getPageWidget();
      },
    );
  }
}
