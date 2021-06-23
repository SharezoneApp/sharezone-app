import 'package:flutter/material.dart';
import 'package:sharezone_website/support_page.dart';

import 'home/home_page.dart';
import 'legal/imprint_page.dart';
import 'legal/privacy_policy.dart';

void main() => runApp(MyApp());

class SharezoneStyle {
  static const primaryColor = Color(0xFF68B3E9);
  static const font = 'Rubik';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sharezone - Vernetzter Schulplaner',
      routes: {
        HomePage.tag: (context) => HomePage(),
        ImprintPage.tag: (context) => ImprintPage(),
        SupportPage.tag: (context) => SupportPage(),
        PrivacyPolicyPage.tag: (context) => PrivacyPolicyPage(),
      },
      theme: ThemeData(
        primaryColor: SharezoneStyle.primaryColor,
        fontFamily: SharezoneStyle.font,
        scaffoldBackgroundColor: Colors.white,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.macOS: FadeTransiationsBuilder(),
          },
        ),
      ),
      home: HomePage(),
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
