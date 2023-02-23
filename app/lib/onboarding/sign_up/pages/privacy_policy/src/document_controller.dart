// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'privacy_policy_src.dart';

// Since if someday we can access the scrollController of the underlying list
// I guess we would probably also expose it here?
/// Used to observe the current [DocumentSectionHeadingPosition] on screen and
/// jump to a specific [DocumentSectionId].
///
/// [DocumentController] abstracts away the underlying [AnchorController] and
/// "translates" the API that is specific to Markdown (e.g. [AnchorPosition])
/// into our own API ([DocumentSectionHeadingPosition]).
class DocumentController {
  final AnchorController anchorController;
  final CurrentlyReadThreshold threshold;

  DocumentController({
    @required this.anchorController,
    @required this.threshold,
  }) {
    anchorController.anchorPositions.addListener(() {
      final anchorPositions = anchorController.anchorPositions.value;
      final sectionPositions =
          anchorPositions.map(_toDocumentSectionPosition).toIList();
      // [sectionPositions] has the same sorting as underlying
      // `ItemPositionsListener.itemPositions`.
      // From experimenting this seems to be sorted in the way the items appear
      // on screen: From top to bottom when scrolling down, from bottom to top
      // when scrolling up.
      //
      // We pre-sort the headings so that the  top-most heading is the first and
      // bottom-most heading is the last in the list.
      _sortedSectionHeadings.value = sectionPositions.sort(
          (pos1, pos2) => pos1.itemLeadingEdge.compareTo(pos2.itemLeadingEdge));
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

  final _sortedSectionHeadings =
      ValueNotifier<IList<DocumentSectionHeadingPosition>>(IList(const []));

  // Sorted so that always the top-most heading is the first and bottom-most
  // heading is the last in the list.
  ValueListenable<IList<DocumentSectionHeadingPosition>>
      get sortedSectionHeadings => _sortedSectionHeadings;

  Future<void> scrollToDocumentSection(DocumentSectionId documentSectionId) {
    return anchorController.scrollToAnchor(
      documentSectionId.id,
      duration: Duration(milliseconds: 100),
      // Overscroll a tiny bit. Otherwise it can sometimes happen that the
      // section / element we scroll to is still not marked as currently read.
      alignment: threshold.position - 0.001,
    );
  }
}
