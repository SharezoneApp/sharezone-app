import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone_widgets/snackbars.dart';

void main() {
  const tapTarget = Key('tap-target');
  const sharezone = 'sharezone';

  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  Future<void> _pumpSnackBarSetup(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ScaffoldMessenger(
          key: scaffoldKey,
          child: Scaffold(),
        ),
      ),
    );
  }

  group('showSnack', () {
    testWidgets('shows given text in a snackbar', (tester) async {
      await _pumpSnackBarSetup(tester);
      expect(find.text(sharezone), findsNothing);

      showSnack(text: sharezone, key: scaffoldKey);
      await tester.pump();

      expect(find.text(sharezone), findsOneWidget);
    });

    testWidgets('shows a snackbar for a given duration', (tester) async {
      const duration = Duration(milliseconds: 500);

      await _pumpSnackBarSetup(tester);

      showSnack(text: sharezone, key: scaffoldKey, duration: duration);
      await tester.pump();

      final snackbar = tester.firstWidget<SnackBar>(find.byType(SnackBar));
      expect(snackbar.duration, duration);
    });

    testWidgets('shows a snackbar with a given SnackBarBehavior',
        (tester) async {
      final fixedBehavior = SnackBarBehavior.fixed;
      await _pumpSnackBarSetup(tester);

      showSnack(behavior: fixedBehavior, key: scaffoldKey);
      await tester.pump();

      final snackbar = tester.firstWidget<SnackBar>(find.byType(SnackBar));
      expect(snackbar.behavior, fixedBehavior);
    });

    testWidgets('shows a snackbar with a loading circle, if it is enabled',
        (tester) async {
      await _pumpSnackBarSetup(tester);

      showSnack(withLoadingCircle: true, key: scaffoldKey);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows a snackbar without a loading circle, if it is disabled',
        (tester) async {
      await _pumpSnackBarSetup(tester);

      showSnack(withLoadingCircle: false, key: scaffoldKey);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows a snackbar with a given SnackBarAction', (tester) async {
      final action = SnackBarAction(label: sharezone, onPressed: () {});

      await _pumpSnackBarSetup(tester);

      showSnack(action: action, key: scaffoldKey);
      await tester.pump();

      final snackbar = tester.firstWidget<SnackBar>(find.byType(SnackBar));
      expect(snackbar.action, action);
    });

    testWidgets('shows a snackbar via BuildContext', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            key: scaffoldKey,
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () => showSnack(context: context, text: sharezone),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 100,
                    width: 100,
                    key: tapTarget,
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text(sharezone), findsNothing);

      // Because of how GestureDetector and the underlying Container interact
      // Flutter thinks we don't hit the target. We do so we ignore the warning.
      // If we wouldn't hit it the expect later wouldn't succeed anyways.
      await tester.tap(find.byKey(tapTarget), warnIfMissed: false);
      await tester.pump();

      expect(find.text(sharezone), findsOneWidget);
    });

    // Fixes snackbar opening bug (Ticket:
    // https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/138).
    // Fixed with:
    // https://gitlab.com/codingbrain/sharezone/sharezone-app/-/merge_requests/386
    testWidgets('closes previous snackbar correctly', (tester) async {
      const firstTapText = 'first tap';
      const secondTapText = 'second tap';

      await _pumpSnackBarSetup(tester);

      showSnack(text: firstTapText, key: scaffoldKey);
      await tester.pump();

      expect(find.text(firstTapText), findsOneWidget);
      expect(find.text(secondTapText), findsNothing);

      // Without this the bug is not triggered by the test
      await tester.pump(const Duration(seconds: 1));

      showSnack(text: secondTapText, key: scaffoldKey);
      await tester.pump();

      expect(find.text(secondTapText), findsOneWidget);
      expect(find.text(firstTapText), findsNothing);
    });
  });
}
