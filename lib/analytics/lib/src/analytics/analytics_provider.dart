import 'package:flutter/material.dart';
import 'backend/null_analytics_backend.dart';

import 'analytics.dart';

class AnalyticsProvider extends InheritedWidget {
  const AnalyticsProvider({
    Key key,
    @required Widget child,
    @required this.analytics,
  }) : super(child: child, key: key);

  final Analytics analytics;

  static Analytics ofOrNullObject(BuildContext context) {
    AnalyticsProvider provider =
        context.findAncestorWidgetOfExactType<AnalyticsProvider>();
    if (provider == null) {
      var loggingAnalyticsBackend = NullAnalyticsBackend();
      print("""
          ATTENTION: 
          AnalyticsProvider was not found in the widget tree. 
          Using Analytics with ${loggingAnalyticsBackend.runtimeType} instead.

          This means that no AnalyticsProvider was given in the widget tree.
          This should be fixed for production use of the app.
          """);
      return Analytics(loggingAnalyticsBackend);
    }
    return provider.analytics;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
