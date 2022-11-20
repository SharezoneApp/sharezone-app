//TODO: Make this class be used by both TOC controller and currently reading
//controller.
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'privacy_policy_src.dart';

// TODO: It might make sense to add a property like .isNearBottomOfDocument
// to make the rest of code more uncoupled from endSection class and behavior.
// Since if someday we can access the scrollController of the underlying list
// I guess we would probably also expose it here?
class DocumentController {
  final AnchorsController anchorsController;
  final CurrentlyReadThreshold threshold;

  DocumentController({
    @required this.anchorsController,
    @required this.threshold,
  }) {
    anchorsController.anchorPositions.addListener(() {
      final anchorPositions = anchorsController.anchorPositions.value;
      final sectionPositions =
          anchorPositions.map(_toDocumentSectionPosition).toIList();
      // Same sorting as underlying `ItemPositionsListener.itemPositions`.
      // From experimenting this seems to be sorted in the way the items appear
      // on screen: From top to bottom when scrolling down, from bottom to top
      // when scrolling up.
      _visibleSectionHeadings.value = sectionPositions;
      // Sorted so that always the top-most heading is the first and bottom-most
      // heading is the last in the list.
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

  // TODO: Do we even need the unsorted headings if we have the sorted ones now?
  final _visibleSectionHeadings =
      ValueNotifier<IList<DocumentSectionHeadingPosition>>(IList(const []));

  ValueListenable<IList<DocumentSectionHeadingPosition>>
      get visibleSectionHeadings => _visibleSectionHeadings;

  final _sortedSectionHeadings =
      ValueNotifier<IList<DocumentSectionHeadingPosition>>(IList(const []));
  ValueListenable<IList<DocumentSectionHeadingPosition>>
      get sortedSectionHeadings => _sortedSectionHeadings;

  Future<void> scrollToDocumentSection(DocumentSectionId documentSectionId) {
    return anchorsController.scrollToAnchor(
      documentSectionId.id,
      duration: Duration(milliseconds: 100),
      // Overscroll a tiny bit. Otherwise it can sometimes happen that the
      // section / element we scroll to is still not marked as currently read.
      alignment: threshold.position - 0.001,
    );
  }
}
