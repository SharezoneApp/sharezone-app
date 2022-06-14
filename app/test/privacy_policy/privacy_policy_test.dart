import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiver/check.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/new_privacy_policy_page.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/table_of_contents_controller.dart';
import 'package:sharezone_utils/random_string.dart';

/// Our custom widget test function that we need to use so that we automatically
/// simulate custom dimensions for the "screen".
///
/// We can't use setUp since we need the [WidgetTester] object to set the
/// dimensions and we only can access it when running [testWidgets].
void _testWidgets(String description, WidgetTesterCallback callback) {
  testWidgets(description, (tester) {
    tester.binding.window.physicalSizeTestValue = Size(1920, 1080);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    return callback(tester);
  });
}

void main() {
  EquatableConfig.stringify = true;
  group(
    'privacy policy page',
    () {
      // TODO: Consider deleting these tests later.
      // Testing this might be done in a more e2e way since we already
      // test the logic in unit tests.
      group('table of contents', () {
        group('section expansion', () {
          _SectionHandler handler;

          setUp(() {
            handler = _SectionHandler();
          });

          // - A section with subsections is not expanded when it is not highlighte
          // * Sections are collapsed by default
          test('All expandable sections are collapsed by default', () {
            final sections = [
              _Section(
                'Foo',
                subsections: const [
                  _Section('Bar'),
                  _Section('Baz'),
                ],
              ),
              _Section(
                'Quz',
                subsections: const [
                  _Section('Xyzzy'),
                ],
              )
            ];

            final result = handler.handleSections(sections);

            expect(
              result.sections,
              [
                _SectionResult('Foo', isExpanded: false),
                _SectionResult('Quz', isExpanded: false),
              ],
            );
          });

          // - When going into a section it expands automatically (even when a subsection is not already highlighted)
          // * A section that is currently read is expanded automatically.
          //   It doesn't matter if a subsection is already marked as currently read (there can be text before the first subsection).
          test('A section that is currently read is expanded automatically.',
              () {
            final sections = [
              _Section(
                'Foo',
                isCurrentlyReading: true,
                subsections: const [
                  _Section('Bar'),
                  _Section('Baz'),
                ],
              ),
              _Section(
                'Quz',
                subsections: const [
                  _Section('Xyzzy'),
                ],
              )
            ];

            final result = handler.handleSections(sections);

            expect(
              result.sections,
              [
                _SectionResult('Foo', isExpanded: true),
                _SectionResult('Quz', isExpanded: false),
              ],
            );
          });

          test(
              'A section in which a subsection is currently read is expanded automatically.',
              () {
            final sections = [
              _Section(
                'Foo',
                subsections: const [
                  _Section('Bar'),
                  _Section('Baz', isCurrentlyReading: true),
                ],
              ),
              _Section(
                'Quz',
                subsections: const [
                  _Section('Xyzzy'),
                ],
              )
            ];

            final result = handler.handleSections(sections);

            expect(
              result.sections,
              [
                _SectionResult('Foo', isExpanded: true),
                _SectionResult('Quz', isExpanded: false),
              ],
            );
          });

          test(
              'When manually toggling the expansion state on a collapsed section (currently not read) it expands',
              () {
            final sections = [
              _Section(
                'Foo',
                subsections: const [
                  _Section('Bar'),
                  _Section('Baz'),
                ],
              ),
              _Section(
                'Quz',
                subsections: const [
                  _Section('Xyzzy'),
                ],
              )
            ];
            handler.handleSections(sections);

            handler.toggleExpansionOfSection('Quz');

            final result = handler.handleSections(sections);
            expect(
              result.sections,
              [
                _SectionResult('Foo', isExpanded: false),
                _SectionResult('Quz', isExpanded: true),
              ],
            );
          });

          test(
              'When manually toggling the expansion state on a manually expanded section (currently not read) it collapses',
              () {
            final sections = [
              _Section(
                'Foo',
                subsections: const [
                  _Section('Bar'),
                  _Section('Baz'),
                ],
              ),
              _Section(
                'Quz',
                subsections: const [
                  _Section('Xyzzy'),
                ],
              )
            ];
            handler.handleSections(sections);

            handler.toggleExpansionOfSection('Quz');
            handler.toggleExpansionOfSection('Quz');

            final result = handler.handleSections(sections);
            expect(
              result.sections,
              [
                _SectionResult('Foo', isExpanded: false),
                _SectionResult('Quz', isExpanded: false),
              ],
            );
          });

          // TODO: Update below - Manually toggling a section open should always
          // leave it open but closing it reverts it back to the default state
          // (open when highlighted).
          // Closing the currently read section (auto-expanded) will close it
          // until it is again currently read.
          //
          // - When pressing the expansion icon on a expanded section it collapses
          // - When being inside a section (thus it is expanded) and pressing the expansion icon it collapses and scrolling inside it wont expand it.
          // - (See above) -> Scrolling back into it expands it again (the manual collapse isn't "saved")
          // - When manually expanding a section and then scrolling inside it then the section is expanded
          // (See above) -> Scrolling out of it collpases it again (the manual expansion isn't "saved")
        });

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
      });
    },
  );
}

class _SectionHandler {
  TableOfContentsController _tocController;

  _SectionHandler() {}

  _SectionsResult handleSections(List<_Section> sections) {
    DocumentSectionId isCurrentlyReadingId;
    for (var section in sections) {
      if (section.isCurrentlyReading) {
        if (isCurrentlyReadingId != null)
          throw ArgumentError('Several sections marked as currently reading');
        isCurrentlyReadingId = DocumentSectionId(section.id);
        break;
      }
      for (var subsection in section.subsections) {
        if (subsection.isCurrentlyReading) {
          if (isCurrentlyReadingId != null)
            throw ArgumentError('Several sections marked as currently reading');
          isCurrentlyReadingId = DocumentSectionId(subsection.id);
          break;
        }
      }
    }

    final _sections = sections
        .map(
          (section) => DocumentSection(
            section.id,
            section.id,
            section.subsections
                .map((subsection) =>
                    DocumentSection(subsection.id, subsection.id))
                .toList(),
          ),
        )
        .toList();

    _tocController ??= TableOfContentsController(
      MockCurrentlyReadingSectionController(
          ValueNotifier<DocumentSectionId>(isCurrentlyReadingId)),
      _sections,
      AnchorsController(),
    );

    final results = _tocController.documentSections
        .map((e) => _SectionResult('${e.id}', isExpanded: e.isExpanded))
        .toList();

    return _SectionsResult(results);
  }

  void toggleExpansionOfSection(String sectionId) {
    _tocController.toggleDocumentSectionExpansion(DocumentSectionId(sectionId));
  }
}

class MockCurrentlyReadingSectionController
    implements CurrentlyReadingSectionController {
  @override
  final ValueNotifier<DocumentSectionId> currentlyReadDocumentSectionOrNull;

  MockCurrentlyReadingSectionController(
      this.currentlyReadDocumentSectionOrNull);
}

class _SectionsResult extends Equatable {
  final List<_SectionResult> sections;

  @override
  List<Object> get props => [sections];

  const _SectionsResult(this.sections);
}

class _SectionResult extends Equatable {
  final bool isExpanded;
  final String id;

  @override
  List<Object> get props => [id, isExpanded];

  const _SectionResult(
    this.id, {
    @required this.isExpanded,
  });
}

class _Section extends Equatable {
  final String id;
  final List<_Section> subsections;
  final bool isCurrentlyReading;

  @override
  List<Object> get props => [id, subsections, isCurrentlyReading];

  const _Section(
    this.id, {
    this.subsections = const [],
    this.isCurrentlyReading = false,
  });
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
