// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:analytics/null_analytics_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/account/theme/theme_settings.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/new_privacy_policy_page.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/privacy_policy_src.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/widgets/privacy_policy_widgets.dart';

/// Our custom widget test function that we need to use so that we automatically
/// simulate custom dimensions for the "screen".
///
/// We can't use setUp since we need the [WidgetTester] object to set the
/// dimensions and we only can access it when running [testWidgets].
@isTest
void _testWidgets(
  String description,
  WidgetTesterCallback callback, {
  Size physicalSize = const Size(1920, 1080),
  double devicePixelRatio = 1.0,
}) {
  testWidgetsWithDimensions(
    description,
    callback,
    physicalSize: physicalSize,
    devicePixelRatio: devicePixelRatio,
  );
}

@isTest
void testWidgetsWithDimensions(
  String description,
  WidgetTesterCallback callback, {
  @required Size physicalSize,
  @required double devicePixelRatio,
}) {
  testWidgets(description, (tester) {
    tester.binding.window.physicalSizeTestValue = physicalSize;
    tester.binding.window.devicePixelRatioTestValue = devicePixelRatio;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    return callback(tester);
  });
}

PrivacyPolicy _privacyPolicyWith({
  @required List<DocumentSection> tableOfContentSections,
  @required String markdown,
}) {
  return PrivacyPolicy(
    lastChanged: DateTime(2022, 03, 04),
    tableOfContentSections: tableOfContentSections,
    version: '2.0.0',
    markdownText: markdown,
    entersIntoForceOnOrNull: null,
    lastSectionHeadingText: 'Metadaten',
  );
}

void main() {
  group(
    'privacy policy page',
    () {
      group('table of contents', () {
        // TODO: Consider deleting these tests later.
        // Testing this might be done in a more e2e way since we already
        // test the logic in unit tests.
        _testWidgets('highlights no section if we havent crossed any yet',
            (tester) async {
          final text = '''
${generateText(10)}
# Inhaltsverzeichnis
${generateText(10)}

${generateText(10)}
''';

          await tester.pumpWidget(
            wrapWithScaffold(
              PrivacyPolicyPage(
                privacyPolicy: _privacyPolicyWith(
                  tableOfContentSections: [
                    DocumentSection('inhaltsverzeichnis', 'Inhaltsverzeichnis'),
                  ],
                  markdown: text,
                ),
              ),
            ),
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
        _testWidgets('highlights section if we have scrolled past it',
            (tester) async {
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
            wrapWithScaffold(PrivacyPolicyPage(
              privacyPolicy: _privacyPolicyWith(
                tableOfContentSections: [
                  DocumentSection('inhaltsverzeichnis', 'Inhaltsverzeichnis'),
                ],
                markdown: text,
              ),
            )),
          );

          await tester.fling(
              find.byType(PrivacyPolicyText), Offset(0, -400), 10000);

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

        /// While developing I used a threshold that was near the top of the
        /// page but not at the very top `threshold: 0.1`. Automatic
        /// scrolling (i.e. tapping on a section heading in the table of
        /// contents) would scroll the heading to the very top though back
        /// then.
        ///
        /// This lead to the case that automatically scrolling to a section
        /// heading of a very small heading might skip this section as the
        /// heading of the next section was already in the threshold.
        ///
        /// With this test we ensure that we scroll the heading always right
        /// up to the threshold.
        _testWidgets('scrolls a section heading always into the threshold',
            (tester) async {
          final text = '''
${generateText(10)}
# Small section
very smoll
# Bigger section
${generateText(10)}

${generateText(10)}
${generateText(10)}



${generateText(10)}
''';

          await tester.pumpWidget(
            wrapWithScaffold(PrivacyPolicyPage(
              privacyPolicy: _privacyPolicyWith(
                tableOfContentSections: [
                  DocumentSection('small-section', 'Small section'),
                  DocumentSection('bigger-section', 'Bigger section'),
                ],
                markdown: text,
              ),
              config: PrivacyPolicyPageConfig(
                // We put the threhold in the middle of the page so that we know
                // that this can't be a fluke (i.e. if we used `0.1` a small
                // section might have still covered the whole threhold.)
                threshold: 0.5,
                showDebugThresholdMarker: true,
              ),
            )),
          );

          // tap on section in table of contents
          await tester
              .tap(find.widgetWithText(SectionHighlight, 'Small section'));

          await tester.pumpAndSettle();

          final smallSectionHighlight = find
              .widgetWithText(SectionHighlight, 'Small section')
              .evaluate()
              .first
              .widget as SectionHighlight;

          expect(smallSectionHighlight.shouldHighlight, true);
        });
      });
    },
  );
}

// Used temporarily when testing so one can see what happens "on the screen" in
// a widget test without having to use a real device / simulator to run these
// tests.
// --update-goldens
Future<void> generateGolden(String name) async {
  await expectLater(find.byType(PrivacyPolicyPage),
      matchesGoldenFile('goldens/golden_$name.png'));
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
  return MaterialApp(
      home: AnalyticsProvider(
    analytics: Analytics(NullAnalyticsBackend()),
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeSettings>(
          create: (context) => ThemeSettings(
            analytics: Analytics(NullAnalyticsBackend()),
            defaultTextScalingFactor: 1.0,
            defaultThemeBrightness: ThemeBrightness.light,
            defaultVisualDensity:
                VisualDensitySetting.adaptivePlatformDensity(),
            keyValueStore: InMemoryKeyValueStore(),
          ),
        ),
      ],
      child: privacyPolicyPage,
    ),
  ));
}
