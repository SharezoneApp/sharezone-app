// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:analytics/observer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/account/theme/theme_settings.dart';
import 'package:sharezone/main/bloc_dependencies.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SharezoneMaterialApp extends StatelessWidget {
  const SharezoneMaterialApp({
    super.key,
    required this.home,
    required this.blocDependencies,
    required this.onUnknownRouteWidget,
    required this.analytics,
    this.routes = const {},
    this.navigatorKey,
  });

  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget home, onUnknownRouteWidget;
  final Map<String, WidgetBuilder> routes;
  final Analytics analytics;
  final BlocDependencies blocDependencies;

  @override
  Widget build(BuildContext context) {
    final themeSettings = context.watch<ThemeSettings>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: PlatformCheck.isWeb ? "Sharezone Web-App" : "Sharezone",
      color: primaryColor,
      darkTheme: darkTheme.copyWith(
          visualDensity: themeSettings.visualDensitySetting.visualDensity),
      theme: lightTheme.copyWith(
          visualDensity: themeSettings.visualDensitySetting.visualDensity),
      themeMode: _getThemeMode(themeSettings.themeBrightness),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('de', 'DE'),
      ],
      navigatorObservers: <NavigatorObserver>[
        AnalyticsNavigationObserver(analytics: analytics)
      ],
      home: home,
      routes: routes,
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (context) => onUnknownRouteWidget),
      navigatorKey: navigatorKey,
    );
  }
}

ThemeMode _getThemeMode(ThemeBrightness themeBrightness) {
  switch (themeBrightness) {
    case ThemeBrightness.dark:
      return ThemeMode.dark;
    case ThemeBrightness.light:
      return ThemeMode.light;
    case ThemeBrightness.system:
      return ThemeMode.system;
  }
}
