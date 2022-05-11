import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:sharezone/widgets/alpha_mode_banner.dart';

void main() {
  group('AlphaModeBanner', () {
    testGoldens(
      'displays the banner correct',
      (tester) async {
        await tester.pumpWidgetBuilder(
          AlphaModeBanner(
            isAlphaVersion: true,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Text("Text"),
              ),
            ),
          ),
        );

        await screenMatchesGolden(tester, 'alpha_mode_banner');
      },
    );

    testWidgets(
      "does not display the banner if app is not a alpha version",
      (tester) async {
        await tester.pumpWidgetBuilder(
          AlphaModeBanner(
            isAlphaVersion: false,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Text("Text"),
              ),
            ),
          ),
        );

        expect(find.byType(Banner), findsNothing);
      },
    );
  });
}
