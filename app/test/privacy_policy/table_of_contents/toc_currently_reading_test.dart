// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/privacy_policy_src.dart';

import '../helper.dart';

DocumentSection _section(String id, {List<DocumentSection> subsections}) {
  return DocumentSection(
      DocumentSectionId(id), id, subsections.toIList() ?? const IListConst([]));
}

DocumentSectionHeadingPosition _headingPosition(
  String sectionId, {
  @required double itemLeadingEdge,
  @required double itemTrailingEdge,
}) {
  return DocumentSectionHeadingPosition(
    DocumentSectionId(sectionId),
    itemLeadingEdge: itemLeadingEdge,
    itemTrailingEdge: itemTrailingEdge,
  );
}

void main() {
  group('the table of contents', () {
    TestCurrentlyReadingController _createController(
      List<DocumentSection> sections,
      // TODO: Delete since its in the setup and can be used/accessed in the
      // method below?
      ValueNotifier<List<DocumentSectionHeadingPosition>> visibleSections, {
      double threshold = 0.1,
      String lastSection,
    }) {
      return TestCurrentlyReadingController(
        sections,
        visibleSections,
        threshold: CurrentlyReadThreshold(threshold),
        lastSection:
            lastSection != null ? DocumentSectionId(lastSection) : null,
      );
    }

    ValueNotifier<List<DocumentSectionHeadingPosition>> visibleSections;

    setUp(() {
      visibleSections = ValueNotifier<List<DocumentSectionHeadingPosition>>([]);
    });

    // TODO: Change "active" to "currently read" in all tests and other places.
    test(
        'doesnt mark any section as active if none are or have been visible on the page',
        () {
      final sections = [
        _section('foo'),
      ];

      final controller = _createController(sections, visibleSections);

      expect(controller.currentlyReadSection, null);
    });

    test(
        'Doesnt mark a section as active when the top of the section is below the threshold',
        () {
      final sections = [
        _section('foo'),
      ];

      final controller =
          _createController(sections, visibleSections, threshold: 0.1);

      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0.11,
          itemTrailingEdge: 0.2,
        ),
      ];

      expect(controller.currentlyReadSection, null);
    });

    test(
        'Marks a section as active when the top of the section touches the threshold',
        () {
      final sections = [
        _section('foo'),
      ];

      final controller =
          _createController(sections, visibleSections, threshold: 0.1);

      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0.1,
          itemTrailingEdge: 0.15,
        ),
      ];

      expect(controller.currentlyReadSection, 'foo');
    });

    test(
        'Marks a section as active when the the section intersects the threshold',
        () {
      final sections = [
        _section('foo'),
      ];

      final controller =
          _createController(sections, visibleSections, threshold: 0.1);

      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0.05,
          itemTrailingEdge: 0.15,
        ),
      ];

      expect(controller.currentlyReadSection, 'foo');
    });
    test(
        'Marks a section as active when the the section is above the threshold',
        () {
      final sections = [
        _section('foo'),
      ];

      final controller =
          _createController(sections, visibleSections, threshold: 0.1);

      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0.05,
          itemTrailingEdge: 0.09,
        ),
      ];

      expect(controller.currentlyReadSection, 'foo');
    });

    test(
        'if currently visible sections go from some to none then it returns the section that comes before the current position inside the document',
        () {
      // TODO: Edge case: Scroll up from first section so that the first
      // section is not visible anymore
      // Scroll down from the last section so that the last section is not visible
      // anymore
      final sections = [
        _section('foo'),
        _section('bar'),
      ];

      final controller = _createController(sections, visibleSections);

      // At bottom of the screen
      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0.8,
          itemTrailingEdge: 0.85,
        ),
      ];

      // We scroll it to the top
      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0.0,
          itemTrailingEdge: 0.05,
        ),
      ];

      // We scroll it out of the view
      visibleSections.value = [];

      expect(controller.currentlyReadSection, 'foo');
    });
    test(
        'marks the one thats past/intersects with the threshold as active when several sections are on screen',
        () {
      final sections = [
        _section('foo'),
        _section('bar'),
        _section('baz'),
        _section('quz'),
      ];

      final controller = _createController(sections, visibleSections);

      // At bottom of the screen
      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0,
          itemTrailingEdge: 0.05,
        ),
        // intersects with thershold - should be active
        _headingPosition(
          'bar',
          itemLeadingEdge: 0.08,
          itemTrailingEdge: 0.12,
        ),
        _headingPosition(
          'baz',
          itemLeadingEdge: 0.2,
          itemTrailingEdge: 0.25,
        ),
        _headingPosition(
          'quz',
          itemLeadingEdge: 0.8,
          itemTrailingEdge: 1,
        ),
      ];

      expect(controller.currentlyReadSection, 'bar');
    });

    test(
        'when scrolling a section title out of viewport and another inside the viewport (at the bottom) it should mark the one scrolled out of the viewport as active',
        () {
      final sections = [
        _section('foo'),
        _section('bar'),
        _section('baz'),
      ];

      final controller = _createController(sections, visibleSections);

      // We scroll to the first section
      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0.8,
          itemTrailingEdge: 0.85,
        ),
      ];

      // We scroll down...
      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0,
          itemTrailingEdge: 0.05,
        ),
      ];

      // ... the first section out of view and the next one into the view at the
      // bottom
      visibleSections.value = [
        _headingPosition(
          'bar',
          itemLeadingEdge: 0.8,
          itemTrailingEdge: 0.85,
        ),
      ];

      expect(controller.currentlyReadSection, 'foo');
    });

    test(
        'marks the section "above" as active when scrolling back up from a previous section',
        () {
      final sections = [
        _section('foo'),
        _section('bar'),
      ];

      final controller = _createController(sections, visibleSections);

      // We scroll the second chapter to the bottom of the screen
      visibleSections.value = [
        _headingPosition(
          'bar',
          itemLeadingEdge: 0.8,
          itemTrailingEdge: 0.85,
        ),
      ];

      // We scroll it to the top post the threshold
      visibleSections.value = [
        _headingPosition(
          'bar',
          itemLeadingEdge: 0,
          itemTrailingEdge: 0.1,
        ),
      ];

      // We the section down to the bottom again (we scroll up the page)
      visibleSections.value = [
        _headingPosition(
          'bar',
          itemLeadingEdge: 0.95,
          itemTrailingEdge: 1,
        ),
      ];

      // We scroll it out of the view (we scroll up the page)
      // We're now in-between foo and bar (both not visible)
      visibleSections.value = [];

      expect(controller.currentlyReadSection, 'foo');
    });

    test('edge case: scrolling above first section', () {
      final sections = [
        _section('foo'),
      ];

      final controller = _createController(sections, visibleSections);

      // We scroll to the first section...
      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0.05,
          itemTrailingEdge: 0.15,
        ),
      ];

      // ... scroll up (section title is now at bottom of the viewport)
      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0.95,
          itemTrailingEdge: 1,
        ),
      ];

      // ...and scroll further up (the first section is now out of view)
      visibleSections.value = [];

      expect(controller.currentlyReadSection, null);
    });

    // TODO: Not sure if this test belongs here.
    // we need to test this since before there was no test for this behavior.
    // im not sure though if I originally didn't want to tie these tests to a
    // notion of a subsection i.e. make this more markdown document based (what
    // is the heading that we're in, doesnt matter what kind) instead of already
    // of already tying to to our model of section/subsection etc.
    // On the other hand it might still be best to do it like this.
    test('A subsection is marked as active correctly', () {
      final sections = [
        _section('foo', subsections: [
          _section('quz'),
          _section('baz'),
        ]),
      ];

      final controller = _createController(sections, visibleSections);

      // We scroll to the first section (its at the bottom)
      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0.9,
          itemTrailingEdge: 0.95,
        ),
      ];

      // We scroll down...
      visibleSections.value = [
        _headingPosition(
          'foo',
          itemLeadingEdge: 0,
          itemTrailingEdge: 0.05,
        ),
      ];

      // ... the first section out of view and the next one into the view at the
      // bottom
      visibleSections.value = [
        _headingPosition(
          'quz',
          itemLeadingEdge: 0.9,
          itemTrailingEdge: 0.95,
        ),
      ];

      // ... to the top
      visibleSections.value = [
        _headingPosition(
          'quz',
          itemLeadingEdge: 0,
          itemTrailingEdge: 0.05,
        ),
      ];

      // ... and out of the view
      visibleSections.value = [];

      expect(controller.currentlyReadSection, 'quz');
    });

    test(
        'regression test: When several sections scroll in and out of view (always at least one visible) then the right section is active',
        () {
      final sections = [
        _section('inhaltsverzeichnis'),
        _section('1-wichtige-begriffe'),
        _section('2-geltungsbereich'),
      ];

      final controller = _createController(sections, visibleSections);

      // We scroll to the first section
      visibleSections.value = [
        _headingPosition(
          'inhaltsverzeichnis',
          itemLeadingEdge: 0.95,
          itemTrailingEdge: 1,
        ),
      ];

      // We scroll down...
      visibleSections.value = [
        _headingPosition(
          'inhaltsverzeichnis',
          itemLeadingEdge: 0,
          itemTrailingEdge: 0.05,
        ),
        _headingPosition(
          '1-wichtige-begriffe',
          itemLeadingEdge: 0.9,
          itemTrailingEdge: 0.95,
        ),
      ];

      // ...and down
      visibleSections.value = [
        _headingPosition(
          '1-wichtige-begriffe',
          itemLeadingEdge: 0.15,
          itemTrailingEdge: 0.2,
        ),
        _headingPosition(
          '2-geltungsbereich',
          itemLeadingEdge: 0.9,
          itemTrailingEdge: 0.95,
        ),
      ];

      // ... now the first two sections are out of view
      // (but the text of the second section is still visible)
      visibleSections.value = [
        _headingPosition(
          '2-geltungsbereich',
          itemLeadingEdge: 0.6,
          itemTrailingEdge: 0.65,
        ),
      ];

      expect(controller.currentlyReadSection, '1-wichtige-begriffe');
    });

    test(
        'regression test: Being inbetween two sections (both headings not visible)',
        () {
      final sections = [
        _section('inhaltsverzeichnis'),
        _section('1-wichtige-begriffe'),
        _section('2-geltungsbereich'),
      ];

      final controller = _createController(sections, visibleSections);

      // We scroll to the first section
      visibleSections.value = [
        _headingPosition(
          'inhaltsverzeichnis',
          itemLeadingEdge: 0.95,
          itemTrailingEdge: 1,
        ),
      ];

      // We scroll down...
      visibleSections.value = [
        _headingPosition(
          'inhaltsverzeichnis',
          itemLeadingEdge: 0,
          itemTrailingEdge: 0.05,
        ),
        _headingPosition(
          '1-wichtige-begriffe',
          itemLeadingEdge: 0.9,
          itemTrailingEdge: 0.95,
        ),
      ];

      // ...down
      visibleSections.value = [
        _headingPosition(
          '1-wichtige-begriffe',
          itemLeadingEdge: 0,
          itemTrailingEdge: 0.05,
        ),
      ];

      // ... we're now between 1-wichtige-begriffe and 2-geltungsbereich
      visibleSections.value = [];

      expect(controller.currentlyReadSection, '1-wichtige-begriffe');
    });

    test(
        'When the trailing edge of the "last heading" is <= 1.0 then the last toc section is highlighted',
        () {
      final sections = [
        _section('bar'),
        _section('baz'),
      ];

      final controller = _createController(
        sections,
        visibleSections,
        lastSection: 'last-section-id',
      );

      visibleSections.value = [
        _headingPosition(
          'bar',
          itemLeadingEdge: 0,
          itemTrailingEdge: 0.1,
        ),
        _headingPosition(
          'baz',
          itemLeadingEdge: 0.6,
          itemTrailingEdge: 0.7,
        ),
        _headingPosition(
          'last-section-id',
          itemLeadingEdge: 0.9,
          // Not 1.0 so it doesn't count yet
          itemTrailingEdge: 1.1,
        ),
      ];

      expect(controller.currentlyReadSection, 'bar');

      visibleSections.value = [
        _headingPosition(
          'bar',
          itemLeadingEdge: 0,
          itemTrailingEdge: 0.1,
        ),
        _headingPosition(
          'baz',
          itemLeadingEdge: 0.6,
          itemTrailingEdge: 0.7,
        ),
        _headingPosition(
          'last-section-id',
          itemLeadingEdge: 0.9,
          itemTrailingEdge: 1.0,
        ),
      ];

      expect(controller.currentlyReadSection, 'baz');

      visibleSections.value = [
        _headingPosition(
          'bar',
          itemLeadingEdge: 0,
          itemTrailingEdge: 0.1,
        ),
        _headingPosition(
          'baz',
          itemLeadingEdge: 0.6,
          itemTrailingEdge: 0.7,
        ),
        _headingPosition(
          'last-section-id',
          itemLeadingEdge: 0.8,
          itemTrailingEdge: 0.9,
        ),
      ];

      expect(controller.currentlyReadSection, 'baz');
    });
  });
}

class TestCurrentlyReadingController {
  final List<DocumentSection> _tocSectionHeadings;
  final ValueListenable<List<DocumentSectionHeadingPosition>>
      _visibleSectionHeadings;

  final ValueNotifier<DocumentSectionId> _currentlyRead =
      ValueNotifier<DocumentSectionId>(null);

  TableOfContentsController _tableOfContentsController;

  String get currentlyReadSection =>
      currentlyReadDocumentSectionOrNull.value?.toString();

  ValueListenable<DocumentSectionId> get currentlyReadDocumentSectionOrNull =>
      _currentlyRead;

  DocumentSectionId _getCurrentlyHighlighted() {
    final highlightedRes = _tableOfContentsController.documentSections
        .where((element) => element.shouldHighlight);
    if (highlightedRes.isEmpty) {
      return null;
    }
    final highlighted = highlightedRes.single;
    final subHighlightedRes =
        highlighted.subsections.where((element) => element.shouldHighlight);
    if (subHighlightedRes.isEmpty) {
      return highlighted.id;
    }
    return subHighlightedRes.single.id;
  }

  TestCurrentlyReadingController(
    this._tocSectionHeadings,
    this._visibleSectionHeadings, {
    @required CurrentlyReadThreshold threshold,
    DocumentSectionId lastSection,
  }) {
    final listenable =
        ValueNotifier<IList<DocumentSectionHeadingPosition>>(IList());

    _visibleSectionHeadings.addListener(() {
      listenable.value = _visibleSectionHeadings.value.toIList();
    });

    final privacyPolicy =
        privacyPolicyWith(tableOfContentSections: _tocSectionHeadings);

    final config = PrivacyPolicyPageConfig(
      threshold: threshold,
      endSection: PrivacyPolicyEndSection(
        sectionName: lastSection?.id ?? 'metadaten',
        generateMarkdown: (pp) => _generateEndSectionMarkdown(lastSection),
      ),
    );

    final documentController = MockDocumentController();
    when(documentController.sortedSectionHeadings).thenReturn(listenable);

    final currentlyReadingController = CurrentlyReadingController(
      documentController: documentController,
      privacyPolicy: privacyPolicy,
      config: config,
    );

    _tableOfContentsController = TableOfContentsController(
      currentlyReadingController: currentlyReadingController,
      documentController: documentController,
      privacyPolicy: privacyPolicy,
      initialExpansionBehavior:
          ExpansionBehavior.leaveManuallyOpenedSectionsOpen,
    );
    _tableOfContentsController.addListener(() {
      _currentlyRead.value = _getCurrentlyHighlighted();
    });
  }
}

class MockDocumentController extends Mock implements DocumentController {}

String _generateEndSectionMarkdown(DocumentSectionId lastSectionId) {
  return '''

#### ${lastSectionId ?? 'metadaten'}
''';
}
