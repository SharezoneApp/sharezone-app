// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_website/sharezone_plus/parents_buy_plus_page.dart';
import 'package:sharezone_website/support_page.dart';

import 'home/home_page.dart';
import 'legal/imprint_page.dart';
import 'legal/privacy_policy.dart';

void main() => runApp(const MyApp());

class SharezoneStyle {
  static const primaryColor = Color(0xFF68B3E9);
  static const font = 'Rubik';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sharezone - Vernetzter Schulplaner',
      onGenerateRoute: (settings) {
        print('args: ${settings.name}');
        switch (settings.name) {
          case ImprintPage.tag:
            return MaterialPageRoute(
              builder: (context) => const ImprintPage(),
              settings: settings,
            );
          case SupportPage.tag:
            return MaterialPageRoute(
              builder: (context) => const SupportPage(),
              settings: settings,
            );
          case PrivacyPolicyPage.tag:
            return MaterialPageRoute(
              builder: (context) => const PrivacyPolicyPage(),
              settings: settings,
            );
          case 'parents-sharezone-plus':
            print(settings.arguments); // prints 'studentId'
            final studentId = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => const ParentsBuyPlusPage(studentId: 'test'),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const HomePage(),
              settings: settings,
            );
        }
      },
      routes: {
        HomePage.tag: (context) => const HomePage(),
        ImprintPage.tag: (context) => const ImprintPage(),
        SupportPage.tag: (context) => const SupportPage(),
        PrivacyPolicyPage.tag: (context) => const PrivacyPolicyPage(),
      },
      theme: ThemeData(
        primaryColor: SharezoneStyle.primaryColor,
        fontFamily: SharezoneStyle.font,
        scaffoldBackgroundColor: Colors.white,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.macOS: FadeTransiationsBuilder(),
          },
        ),
      ),
      home: const HomePage(),
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
