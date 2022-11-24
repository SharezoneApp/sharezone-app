// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/privacy_policy_src.dart';
import 'package:test/test.dart';

import '../helper.dart';
import 'toc_currently_reading_test.dart';

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
            DocumentSectionId(section.id),
            section.id,
            section.subsections
                .map((subsection) => DocumentSection(
                    DocumentSectionId(subsection.id), subsection.id))
                .toIList(),
          ),
        )
        .toList();

    _currentlyReadingNotifier ??= ValueNotifier<DocumentSectionId>(null);

    _tocController ??= TableOfContentsController(
      currentlyReadingController:
          MockCurrentlyReadingController(_currentlyReadingNotifier),
      privacyPolicy: privacyPolicyWith(tableOfContentSections: _sections),
      documentController: MockDocumentController(),
      initialExpansionBehavior:
          ExpansionBehavior.leaveManuallyOpenedSectionsOpen,
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

class MockCurrentlyReadingController implements CurrentlyReadingController {
  @override
  final ValueNotifier<DocumentSectionId> currentlyReadDocumentSectionOrNull;

  MockCurrentlyReadingController(this.currentlyReadDocumentSectionOrNull);
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
      // TODO: Rename Section to Chapter?
      // TODO: Remove `isCurrentlyReading` property?
      // TODO: Test different ExpansionBehavior?
      test('Expandable sections are collapsed by default', () {
        final sections = [
          _Section(
            'Foo',
            subsections: const [
              _Section('Bar'),
              _Section('Baz'),
            ],
          )
        ];

        tocController.build(sections);

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: false),
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
        ];
        tocController.build(sections);

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: false),
          ],
        );

        tocController.toggleExpansionOfSection('Foo');

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: true),
          ],
        );
      });

      test(
          'When manually toggling the expansion state on a manually expanded section (currently not read) it collapses',
          () {
        final sections = [
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
        ];
        tocController.build(sections);

        tocController.toggleExpansionOfSection('Foo');
        tocController.markAsCurrentlyRead('Foo');
        tocController.markAsCurrentlyRead(null);

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: true),
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

        // We "scroll" around in the subchapters and the main chapter of Foo
        tocController.markAsCurrentlyRead('Bar');
        tocController.markAsCurrentlyRead('Baz');
        tocController.markAsCurrentlyRead('Foo');
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
          'When manually collapsing a section that is not(!) currently read and scrolling in and out of then it will expand automatically again (default behavior)',
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

        // We expand it manually
        tocController.toggleExpansionOfSection('Foo');
        // We collapse it manually
        tocController.toggleExpansionOfSection('Foo');
        // "Scroll" to Foo
        tocController.markAsCurrentlyRead('Foo');

        expect(
          tocController.currentState.sections,
          [
            _SectionResult('Foo', isExpanded: true),
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
    });
  });
}
