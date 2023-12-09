// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sharezone_website/support_page.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

import 'home/home_page.dart';
import 'legal/imprint_page.dart';
import 'legal/privacy_policy.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class SharezoneStyle {
  static const primaryColor = Color(0xFF68B3E9);
  static const font = 'Rubik';
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
      routes: <RouteBase>[
        GoRoute(
          path: ImprintPage.tag,
          builder: (BuildContext context, GoRouterState state) {
            return const ImprintPage();
          },
        ),
        GoRoute(
          path: SupportPage.tag,
          builder: (BuildContext context, GoRouterState state) {
            return const SupportPage();
          },
        ),
        GoRoute(
          path: PrivacyPolicyPage.tag,
          builder: (BuildContext context, GoRouterState state) {
            return const PrivacyPolicyPage();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Sharezone - Vernetzter Schulplaner',
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: SharezoneStyle.primaryColor,
        fontFamily: SharezoneStyle.font,
        scaffoldBackgroundColor: Colors.white,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.macOS: FadeTransiationsBuilder(),
          },
        ),
      ),
    );
  }
}

class FadeTransiationsBuilder extends PageTransitionsBuilder {
  /// Construct a [FadeTransiationsBuilder].
  const FadeTransiationsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
