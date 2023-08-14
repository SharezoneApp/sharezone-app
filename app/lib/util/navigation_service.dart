// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

// Can be used to navigate without context;
class NavigationService extends BlocBase {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T> pushNamed<T>(String routeName) async {
    return navigatorKey.currentState.pushNamed<T>(routeName);
  }

  Future<T> pushNamedWithDefault<T>(String routeName,
      {@required T defaultValue}) async {
    assert(defaultValue != null);
    final result = await navigatorKey.currentState.pushNamed<T>(routeName);
    if (result == null) return defaultValue;
    return result;
  }

  Future<T> pushWidget<T>(Widget widget, {@required String name}) async {
    return navigatorKey.currentState.push<T>(MaterialPageRoute(
        builder: (context) => widget, settings: RouteSettings(name: name)));
  }

  Future<T> pushWidgetWithDefault<T>(Widget widget,
      {@required T defaultValue}) async {
    assert(defaultValue != null);
    final result = await navigatorKey.currentState
        .push<T>(MaterialPageRoute(builder: (context) => widget));
    if (result == null) return defaultValue;
    return result;
  }

  void pop<T>(T result) {
    navigatorKey.currentState.pop(result);
  }

  @override
  void dispose() {}
}

@optionalTypeArgs
Future<T> pushWithDefault<T extends Object>(
  BuildContext context,
  Widget widget, {
  @required T defaultValue,
  @required String name,
}) async {
  assert(defaultValue != null);
  final result = await Navigator.push<T>(
    context,
    IgnoreWillPopScopeWhenIosSwipeBackRoute(
      builder: (context) => widget,
      settings: RouteSettings(name: name),
    ),
  );
  if (result == null) {
    return defaultValue;
  }
  return result;
}
