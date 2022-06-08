import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/new_privacy_policy_page.dart';
import 'package:sharezone_utils/random_string.dart';

void main() {
  group(
    'privacy policy page',
    () {
      // TODO: Consider deleting these tests later.
      // Testing this might be done in a more e2e way since we already
      // test the logic in unit tests.
      group('table of contents', () {
        testWidgets('highlights no section if we havent crossed any yet',
            (tester) async {
          tester.binding.window.physicalSizeTestValue = Size(1920, 1080);
          tester.binding.window.devicePixelRatioTestValue = 1.0;
          addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

          final text = '''
${generateText(10)}
# Inhaltsverzeichnis
${generateText(10)}

${generateText(10)}
''';

          await tester.pumpWidget(
            wrapWithScaffold(NewPrivacyPolicy(
              content: text,
              documentSections: [
                DocumentSection('inhaltsverzeichnis', 'Inhaltsverzeichnis'),
              ],
            )),
          );

          expect(
              find.byWidgetPredicate((widget) =>
                  widget is SectionHighlight &&
                  widget.shouldHighlight == false),
              findsOneWidget);
          expect(
              find.byWidgetPredicate((widget) =>
                  widget is SectionHighlight && widget.shouldHighlight == true),
              findsNothing);
        });
        testWidgets('highlights section if we have scrolled past it',
            (tester) async {
          tester.binding.window.physicalSizeTestValue = Size(1920, 1080);
          tester.binding.window.devicePixelRatioTestValue = 1.0;
          addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

          final text = '''
Test test test

test 

test

# Inhaltsverzeichnis
${generateText(10)}

${generateText(10)}
${generateText(10)}



${generateText(10)}
''';

          await tester.pumpWidget(
            wrapWithScaffold(NewPrivacyPolicy(
              content: text,
              documentSections: [
                DocumentSection('inhaltsverzeichnis', 'Inhaltsverzeichnis'),
              ],
            )),
          );

          await expectLater(find.byType(NewPrivacyPolicy),
              matchesGoldenFile('goldens/golden_pp1.png'));

          // await tester.flingFrom(Offset(0, 0), Offset(0, -100), 10000);
          await tester.fling(
              find.byType(PrivacyPolicyText), Offset(0, -400), 10000);
          await tester.pumpAndSettle();

          expect(
              find.byWidgetPredicate((widget) =>
                  widget is SectionHighlight && widget.shouldHighlight == true),
              findsOneWidget);
          expect(
              find.byWidgetPredicate((widget) =>
                  widget is SectionHighlight &&
                  widget.shouldHighlight == false),
              findsNothing);
        });
      });
    },
  );
}

// Used temporarily when testing so one can see what happens "on the screen" in
// a widget test without having to use a real device / simulator to run these
// tests.
Future<void> generateGolden() async {
  await expectLater(find.byType(NewPrivacyPolicy),
      matchesGoldenFile('goldens/golden_pp2.png'));
}

String generateText(int times) {
  return """
Lorem ipsum dolor sit amet.

Lorem ipsum dolor sit amet, consetetur sadipscing elitrsed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. 
At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.
Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
""" *
      times;
}

Widget wrapWithScaffold(Widget privacyPolicyPage) {
  return MaterialApp(home: privacyPolicyPage);
}
