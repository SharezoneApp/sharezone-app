import 'package:flutter/material.dart';

class IgnoreWillPopScopeWhenIosSwipeBackRoute<T> extends MaterialPageRoute<T> {
  @override
  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }
  IgnoreWillPopScopeWhenIosSwipeBackRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}