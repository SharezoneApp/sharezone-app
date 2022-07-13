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

import '../privacy_policy_src.dart';

// TODO: Is this still needed?
// TODO: Make nicer, copied it from else where.
/// A section means content beneath a markdown heading e.g. the following
/// example would a section called "Data protection officer."
/// ```markdown
/// ## Data protection officer
/// Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy
/// eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam
/// voluptua. At vero eos et accusam et justo duo dolores et ea rebum.
/// ```
class DocumentSection {
  // TODO: Remove sectionId and replace with documentSectionId.
  final String sectionId;
  DocumentSectionId get documentSectionId => DocumentSectionId(sectionId);
  final String sectionName;
  final List<DocumentSection> subsections;

  DocumentSection(this.sectionId, this.sectionName,
      [this.subsections = const []]);

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

  DocumentSectionController(this._anchorsController) {
    _anchorsController.anchorPositions.addListener(() {
      final anchorPositions = _anchorsController.anchorPositions.value;
      final sectionPositions =
          anchorPositions.map(_toDocumentSectionPosition).toList();
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

  // TODO: Use IList instead?
  final _visibleSectionHeadings =
      ValueNotifier<List<DocumentSectionHeadingPosition>>([]);

  ValueListenable<List<DocumentSectionHeadingPosition>>
      get visibleSectionHeadings => _visibleSectionHeadings;

  Future<void> scrollToDocumentSection(DocumentSectionId documentSectionId) {
    return _anchorsController.scrollToAnchor(documentSectionId.id);
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
  final List<DocumentSection> _allDocumentSections;
  final ScrollToDocumentSectionFunc _scrollToDocumentSection;

  TableOfContents _tableOfContents;

  factory TableOfContentsController({
    @required DocumentSectionController documentSectionController,
    @required List<DocumentSection> tocDocumentSections,
  }) {
    return TableOfContentsController.internal(
      CurrentlyReadingSectionController(tocDocumentSections,
          documentSectionController.visibleSectionHeadings),
      tocDocumentSections,
      documentSectionController.scrollToDocumentSection,
    );
  }

  @visibleForTesting
  TableOfContentsController.internal(
    this._activeSectionController,
    this._allDocumentSections,
    this._scrollToDocumentSection,
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
                      subsections: IList([]),
                      expansionState: ExpansionState(
                        expansionMode: ExpansionMode.automatic,
                        isExpanded: false,
                      ),
                      isThisCurrentlyRead: false,
                    ),
                  )
                  .toIList(),
              isThisCurrentlyRead: false,
              expansionState: ExpansionState(
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

  List<TocDocumentSectionView> _documentSections;
  List<TocDocumentSectionView> get documentSections =>
      UnmodifiableListView(_documentSections);

  void _updateViews() {
    _documentSections =
        _tableOfContents.sections.map((section) => _toView(section)).toList();
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
              subsections: [],
            ),
          )
          .toList(),
    );
  }
}
