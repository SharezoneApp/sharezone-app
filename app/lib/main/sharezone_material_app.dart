// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:analytics/observer.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/account/theme/theme_bloc.dart';
import 'package:sharezone/account/theme/theme_brightness.dart';
import 'package:sharezone/account/theme/theme_settings_notifier.dart';
import 'package:sharezone/blocs/bloc_dependencies.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';
import 'package:sharezone/util/theme/brightness_cache.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/theme.dart';

class SharezoneMaterialApp extends StatelessWidget {
  const SharezoneMaterialApp({
    @required this.home,
    @required this.blocDependencies,
    @required this.onUnknownRouteWidget,
    this.routes = const {},
    this.navigatorKey,
    this.analytics,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget home, onUnknownRouteWidget;
  final Map<String, WidgetBuilder> routes;
  final Analytics analytics;
  final BlocDependencies blocDependencies;

  @override
  Widget build(BuildContext context) {
    // final brightnessCache = BrightnessCache(
    //     streamingCache: FlutterStreamingKeyValueStore(
    //         blocDependencies.streamingSharedPreferences));
    // final themeBloc = ThemeBloc(brightnessCache: brightnessCache);

    final themeSettings = Provider.of<ThemeSettingsNotifier>(context);

    return FeatureDiscovery(
      child: Theme(
        data: ThemeData(visualDensity: themeSettings.visualDensity),
        child: MediaQuery(
          data: MediaQueryData(
            textScaleFactor: themeSettings.textScalingFactor,
          ),
          child: Builder(builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: PlatformCheck.isWeb ? "Sharezone Web-App" : "Sharezone",
              color: primaryColor,
              darkTheme: themeSettings.themeBrightness == ThemeBrightness.system
                  ? darkTheme
                  : null,
              theme: themeSettings.themeBrightness == ThemeBrightness.dark
                  ? darkTheme
                  : lightTheme,
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
          }),
        ),
      ),
    );
  }
}
