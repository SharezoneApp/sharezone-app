import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/new_privacy_policy_page.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/table_of_contents_controller.dart';
import 'package:test/test.dart';

class _TableOfContentsTestController {
  TableOfContentsController _tocController;
  ValueNotifier<DocumentSectionId> _currentlyReadingNotifier;

  _TocState get currentState {
    final results = _tocController.documentSections
        .map((e) => _SectionResult('${e.id}', isExpanded: e.isExpanded))
        .toList();

    return _TocState(results);
  }

  _TocState build(List<_Section> sections) {
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

    _currentlyReadingNotifier ??= ValueNotifier<DocumentSectionId>(null);
    _tocController ??= TableOfContentsController(
      MockCurrentlyReadingSectionController(_currentlyReadingNotifier),
      _sections,
      AnchorsController(),
    );

    final results = _tocController.documentSections
        .map((e) => _SectionResult('${e.id}', isExpanded: e.isExpanded))
        .toList();

    return _TocState(results);
  }

  void toggleExpansionOfSection(String sectionId) {
    _tocController.toggleDocumentSectionExpansion(DocumentSectionId(sectionId));
  }

  void markAsCurrentlyRead(String sectionId) {
    if (sectionId == null) {
      _currentlyReadingNotifier.value = null;
    } else {
      _currentlyReadingNotifier.value = DocumentSectionId(sectionId);
    }
  }
}

class MockCurrentlyReadingSectionController
    implements CurrentlyReadingSectionController {
  @override
  final ValueNotifier<DocumentSectionId> currentlyReadDocumentSectionOrNull;

  MockCurrentlyReadingSectionController(
      this.currentlyReadDocumentSectionOrNull);
}

class _TocState extends Equatable {
  final List<_SectionResult> sections;

  @override
  List<Object> get props => [sections];

  const _TocState(this.sections);
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

  @override
  List<Object> get props => [id, subsections];

  const _Section(
    this.id, {
    this.subsections = const [],
  });
}

void main() {
  EquatableConfig.stringify = true;
  group('Table of Contents', () {
    group('section expansion', () {
      _TableOfContentsTestController tocController;

      setUp(() {
        tocController = _TableOfContentsTestController();
      });

      // - A section with subsections is not expanded when it is not highlighte
      // * Sections are collapsed by default
      // TODO: Remove unnecessary sections in some tests that are not
      // relevant to that specific test.
      // TODO: Instead of Foo etc use section titles that are more "real"?
      // TODO: Rename Section to Chapter?
      // TODO: Remove `isCurrentlyReading` property?
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

        tocController.build(sections);

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: false),
            _SectionResult('Quz', isExpanded: false),
          ],
        );
      });

      // - When going into a section it expands automatically (even when a subsection is not already highlighted)
      // * A section that is currently read is expanded automatically.
      //   It doesn't matter if a subsection is already marked as currently read (there can be text before the first subsection).
      test('A section that is currently read is expanded automatically.', () {
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

        tocController.build(sections);
        tocController.markAsCurrentlyRead('Foo');

        expect(
          tocController.currentState.sections,
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

        tocController.build(sections);
        tocController.markAsCurrentlyRead('Baz');

        expect(
          tocController.currentState.sections,
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
        tocController.build(sections);

        tocController.toggleExpansionOfSection('Quz');

        expect(
          tocController.currentState.sections,
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
        tocController.build(sections);

        tocController.toggleExpansionOfSection('Quz');
        tocController.toggleExpansionOfSection('Quz');

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: false),
            _SectionResult('Quz', isExpanded: false),
          ],
        );
      });
      test(
          'When manually expanding a section it stays open even if it the user finishes reading it',
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
          ),
        ];
        tocController.build(sections);

        tocController.toggleExpansionOfSection('Foo');
        tocController.markAsCurrentlyRead('Foo');
        tocController.markAsCurrentlyRead('Quz');
        tocController.markAsCurrentlyRead(null);

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: true),
            _SectionResult('Quz', isExpanded: false),
          ],
        );
      });
      test(
          'When manually collapsing a section that is currently read it will stay closed when switching between its subchapters',
          () {
        final sections = [
          _Section(
            'Foo',
            subsections: const [
              _Section('Bar'),
              _Section('Baz'),
            ],
          ),
        ];
        tocController.build(sections);

        // Will expand it automatically
        tocController.markAsCurrentlyRead('Foo');
        // We collapse it manually
        tocController.toggleExpansionOfSection('Foo');

        // We "scroll" around in the subchapters of Foo
        tocController.markAsCurrentlyRead('Bar');
        tocController.markAsCurrentlyRead('Baz');
        tocController.markAsCurrentlyRead('Bar');

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: false),
          ],
        );
      });
      test(
          'When manually collapsing a section that is currently read and scrolling in and out of then it will expand automatically again (default behavior)',
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
        tocController.build(sections);

        // Will expand it automatically
        tocController.markAsCurrentlyRead('Foo');
        // We collapse it manually
        tocController.toggleExpansionOfSection('Foo');
        // "Scroll" out of the Foo chapter to Quz
        tocController.markAsCurrentlyRead('Quz');
        // "Scroll" back to Foo
        tocController.markAsCurrentlyRead('Foo');

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: true),
            _SectionResult('Quz', isExpanded: false),
          ],
        );
      });
      test(
          'When manually collapsing a section that is currently not read and scrolling in and out of then it will expand automatically again (default behavior)',
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
        tocController.build(sections);

        // We expand it manually
        tocController.markAsCurrentlyRead('Foo');
        // We collapse it manually
        tocController.toggleExpansionOfSection('Foo');
        // "Scroll" out of the Foo chapter to Quz
        tocController.markAsCurrentlyRead('Quz');
        // "Scroll" back to Foo
        tocController.markAsCurrentlyRead('Foo');

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: true),
            _SectionResult('Quz', isExpanded: false),
          ],
        );
      });

      // TODO: Can be deleted later probably, was just so that my temp
      // solution for the single section in tests above is forced to work
      //for multiple sections.
      test('Collapsing and Expanding multiple sections', () {
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
          ),
          _Section(
            'Moa',
            subsections: const [
              _Section('Zuz'),
            ],
          )
        ];
        tocController.build(sections);

        tocController.toggleExpansionOfSection('Foo');
        tocController.toggleExpansionOfSection('Quz');
        tocController.markAsCurrentlyRead('Moa');

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: true),
            _SectionResult('Quz', isExpanded: true),
            _SectionResult('Moa', isExpanded: true),
          ],
        );
      });

      // We had the bug that when collapsing and then extending a section you
      // had to press two times to expand the section.
      test(
          'regression test: manually collapsing and expanding a section that is currently read',
          () {
        final sections = [
          _Section(
            'Foo',
            subsections: const [
              _Section('Bar'),
              _Section('Baz'),
            ],
          ),
        ];

        tocController.build(sections);

        // Will expand it automatically
        tocController.markAsCurrentlyRead('Foo');
        // Close is manually
        tocController.toggleExpansionOfSection('Foo');
        // Open it manually again
        tocController.toggleExpansionOfSection('Foo');

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: true),
          ],
        );
      });
      test(
          'regression test: reading a manually collapsed section should expand it',
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
          ),
        ];

        tocController.build(sections);

        // Open manually
        tocController.toggleExpansionOfSection('Foo');
        // Close manually
        tocController.toggleExpansionOfSection('Foo');

        tocController.markAsCurrentlyRead('Foo');

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: true),
            _SectionResult('Quz', isExpanded: false),
          ],
        );
      });
    });
  });
}
