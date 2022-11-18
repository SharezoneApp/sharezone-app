// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/widgets/privacy_policy_widgets.dart';

import '../privacy_policy_src.dart';

/// A model of a section (or chapter) of the markdown document.
/// Used by the table of contents to list and navigate to specific sections of
/// the privacy policy.
///
/// A section is created inside the markdown document by an headline with
/// following content:
/// ```markdown
/// # Section
/// Lorem Ipsum
/// ## Subsection
/// Bla bla bla
/// ```
///
/// This will create the following [DocumentSection]:
/// ```dart
/// DocumentSection('section', 'Section', [
///   DocumentSection('subsection', 'Subsection'),
/// ]);
/// ```
class DocumentSection {
  // TODO: Remove sectionId and replace with documentSectionId.
  final String sectionId;
  DocumentSectionId get documentSectionId => DocumentSectionId(sectionId);
  final String sectionName;
  final IList<DocumentSection> subsections;

  DocumentSection(this.sectionId, this.sectionName,
      [this.subsections = const IListConst([])]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is DocumentSection &&
        other.sectionId == sectionId &&
        other.sectionName == sectionName &&
        listEquals(other.subsections, subsections);
  }

  @override
  int get hashCode =>
      sectionId.hashCode ^ sectionName.hashCode ^ subsections.hashCode;

  @override
  String toString() =>
      'DocumentSection(sectionId: $sectionId, sectionName: $sectionName, subsections: $subsections)';
}

/// The position of the heading with [documentSectionId] on the screen.
/// Used to compute which document section is currently read (see
/// [CurrentlyReadingSectionController]).
///
/// This is analogus to the [ItemPosition] of the [ScrollablePositionedList]
/// used by [RelativeAnchorsMarkdown] to display the markdown.
class DocumentSectionHeadingPosition {
  final DocumentSectionId documentSectionId;
  final double itemLeadingEdge;
  final double itemTrailingEdge;

  DocumentSectionHeadingPosition(
    this.documentSectionId, {
    @required this.itemLeadingEdge,
    @required this.itemTrailingEdge,
  });

  @override
  String toString() {
    return 'DocumentSectionPosition(itemLeadingEdge: $itemLeadingEdge, itemTrailingEdge: $itemTrailingEdge, documentSectionId: $documentSectionId)';
  }
}

class DocumentSectionController {
  final AnchorsController _anchorsController;
  final CurrentlyReadThreshold threshold;

  DocumentSectionController(
    this._anchorsController, {
    @required this.threshold,
  }) {
    _anchorsController.anchorPositions.addListener(() {
      final anchorPositions = _anchorsController.anchorPositions.value;
      final sectionPositions =
          anchorPositions.map(_toDocumentSectionPosition).toIList();
      _visibleSectionHeadings.value = sectionPositions;
    });
  }

  DocumentSectionHeadingPosition _toDocumentSectionPosition(
      AnchorPosition anchorPosition) {
    return DocumentSectionHeadingPosition(
      DocumentSectionId(anchorPosition.anchor.id),
      itemLeadingEdge: anchorPosition.itemLeadingEdge,
      itemTrailingEdge: anchorPosition.itemTrailingEdge,
    );
  }

  final _visibleSectionHeadings =
      ValueNotifier<IList<DocumentSectionHeadingPosition>>(IList(const []));

  ValueListenable<IList<DocumentSectionHeadingPosition>>
      get visibleSectionHeadings => _visibleSectionHeadings;

  Future<void> scrollToDocumentSection(DocumentSectionId documentSectionId) {
    return _anchorsController.scrollToAnchor(
      documentSectionId.id,
      duration: Duration(milliseconds: 100),
      // Overscroll a tiny bit. Otherwise it can sometimes happen that the
      // section / element we scroll to is still not marked as currently read.
      alignment: threshold.position - 0.001,
    );
  }
}

// TODO: Remove this?
typedef ScrollToDocumentSectionFunc = Future<void> Function(
    DocumentSectionId documentSectionId);

class TableOfContentsController extends ChangeNotifier {
  final CurrentlyReadingSectionController _activeSectionController;
  // TODO: Change name
  // They are not really all sections but only the sections that we want
  // to display in the table of contents.
  final IList<DocumentSection> _allDocumentSections;
  final ScrollToDocumentSectionFunc _scrollToDocumentSection;
  final ExpansionBehavior _initalExpansionBehavior;

  TableOfContents _tableOfContents;

  factory TableOfContentsController({
    @required DocumentSectionController documentSectionController,
    @required IList<DocumentSection> tocDocumentSections,
    @required ExpansionBehavior initialExpansionBehavior,
    // TODO: Document why we have to use this workaround.
    // Can't see if we have reached bottom of document i think as we cant access
    // ScrollController when using ScrollablePositionedList.
    @required PrivacyPolicyEndSection endSection,
    @required CurrentlyReadThreshold threshold,
  }) {
    return TableOfContentsController.internal(
      CurrentlyReadingSectionController(
        tocDocumentSections,
        documentSectionController.visibleSectionHeadings,
        endSection: endSection,
        threshold: threshold,
      ),
      tocDocumentSections,
      documentSectionController.scrollToDocumentSection,
      initialExpansionBehavior,
    );
  }

  @visibleForTesting
  TableOfContentsController.internal(
    this._activeSectionController,
    this._allDocumentSections,
    this._scrollToDocumentSection,
    this._initalExpansionBehavior,
  ) {
    final sections = _allDocumentSections
        .map((e) => TocSection(
              id: e.documentSectionId,
              title: e.sectionName,
              subsections: e.subsections
                  .map(
                    (sub) => TocSection(
                      id: sub.documentSectionId,
                      title: sub.sectionName,
                      subsections: IList(const []),
                      expansionState: ExpansionState(
                        expansionBehavior: _initalExpansionBehavior,
                        expansionMode: ExpansionMode.automatic,
                        isExpanded: false,
                      ),
                      isThisCurrentlyRead: false,
                    ),
                  )
                  .toIList(),
              isThisCurrentlyRead: false,
              expansionState: ExpansionState(
                expansionBehavior: _initalExpansionBehavior,
                expansionMode: ExpansionMode.automatic,
                isExpanded: false,
              ),
            ))
        .toIList();
    _tableOfContents = TableOfContents(sections);

    _updateViews();

    _activeSectionController.currentlyReadDocumentSectionOrNull.addListener(() {
      final currentlyReadSection =
          _activeSectionController.currentlyReadDocumentSectionOrNull.value;
      _tableOfContents =
          _tableOfContents.changeCurrentlyReadSectionTo(currentlyReadSection);
      _updateViews();
    });
  }

  // TODO: Test
  void changeExpansionBehavior(ExpansionBehavior expansionBehavior) {
    _tableOfContents =
        _tableOfContents.changeExpansionBehaviorTo(expansionBehavior);
  }

  // TODO: Parameters - how much space
  // TODO: Should have at least on mobile a little bit more space above the
  // heading we scroll to.
  Future<void> scrollTo(DocumentSectionId documentSectionId) {
    return _scrollToDocumentSection(documentSectionId);
  }

  void toggleDocumentSectionExpansion(DocumentSectionId documentSectionId) {
    _tableOfContents =
        _tableOfContents.forceToggleExpansionOf(documentSectionId);

    _updateViews();
  }

  IList<TocDocumentSectionView> _documentSections;
  IList<TocDocumentSectionView> get documentSections => _documentSections;

  void _updateViews() {
    _documentSections =
        _tableOfContents.sections.map((section) => _toView(section)).toIList();
    notifyListeners();
  }

  TocDocumentSectionView _toView(TocSection documentSection) {
    return TocDocumentSectionView(
      id: documentSection.id,
      isExpanded: documentSection.isExpanded,
      sectionHeadingText: documentSection.title,
      shouldHighlight: documentSection.isThisOrASubsectionCurrentlyRead,
      subsections: documentSection.subsections
          .map(
            (subsection) => TocDocumentSectionView(
              id: subsection.id,
              isExpanded: subsection.isExpanded,
              sectionHeadingText: subsection.title,
              shouldHighlight: subsection.isThisOrASubsectionCurrentlyRead,
              subsections: const IListConst([]),
            ),
          )
          .toIList(),
    );
  }
}
