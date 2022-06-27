import 'package:bloc_base/bloc_base.dart';
import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rxdart/subjects.dart';

import 'privacy_policy_src.dart';

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

class PrivacyPolicyBloc extends BlocBase {
  final AnchorsController anchorsController;
  final List<DocumentSection> sections;

  final documentSections =
      BehaviorSubject<List<DocumentSectionHeadingPosition>>();

  PrivacyPolicyBloc(this.anchorsController, this.sections) {
    anchorsController.anchorPositions.addListener(() {
      final pos = anchorsController.anchorPositions.value;
      final sections =
          pos.map((pos) => _toDocumentSectionPosition(pos)).toList();
      documentSections.add(sections);
    });
  }

  DocumentSectionHeadingPosition _toDocumentSectionPosition(
      AnchorPosition anchorPosition) {
    return DocumentSectionHeadingPosition(
      DocumentSection(anchorPosition.anchor.id, anchorPosition.anchor.text),
      itemLeadingEdge: anchorPosition.itemLeadingEdge,
      itemTrailingEdge: anchorPosition.itemTrailingEdge,
    );
  }

  List<DocumentSection> getAllDocumentSections() {
    return sections;
  }

  List<TocDocumentSectionView> getTocDocumentSections() {
    return [];
  }

  void scrollToSection(String documentSectionId) {
    anchorsController.scrollToAnchor(documentSectionId);
  }

  @override
  void dispose() {
    documentSections.close();
  }
}

class DocumentSectionHeadingPosition {
  final DocumentSection documentSection;
  final double itemLeadingEdge;
  final double itemTrailingEdge;

  DocumentSectionHeadingPosition(
    this.documentSection, {
    @required this.itemLeadingEdge,
    @required this.itemTrailingEdge,
  });

  @override
  String toString() {
    return 'DocumentSectionPosition(itemLeadingEdge: $itemLeadingEdge, itemTrailingEdge: $itemTrailingEdge, documentSection: $documentSection)';
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
      DocumentSection(anchorPosition.anchor.id, anchorPosition.anchor.text),
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
                      isExpanded: false,
                      isThisCurrentlyRead: false,
                      expansionMode: ExpansionMode.automatic,
                    ),
                  )
                  .toIList(),
              isExpanded: false,
              isThisCurrentlyRead: false,
              expansionMode: ExpansionMode.automatic,
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

  Future<void> scrollTo(DocumentSectionId documentSectionId) {
    return _scrollToDocumentSection(documentSectionId);
  }

  void toggleDocumentSectionExpansion(DocumentSectionId documentSectionId) {
    _tableOfContents =
        _tableOfContents.manuallyToggleShowSubsectionsOf(documentSectionId);

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

/// Updates which [DocumentSection] inside the table of contents the user is
/// currently reading.
///
/// This is done by looking at what [DocumentSection] headings (e.g.
/// `## Foo Heading`) are/were inside the viewport and working out where the
/// user is currently inside the text.
class CurrentlyReadingSectionController {
  final List<DocumentSection> _tocSectionHeadings;
  final ValueListenable<List<DocumentSectionHeadingPosition>>
      _visibleSectionHeadings;

  // We flatten all sections and their subsections into one list.
  // E.g.
  /// ```dart
  /// // prints:
  /// [DocumentSection(id: 'foo', subsections: [
  ///   DocumentSection(id: 'sub-foo', subsections: []),
  /// ]),
  /// DocumentSection(id: 'bar', subsections: []),
  /// ];
  /// print(allDocumentSections);
  ///
  /// // prints:
  /// // (Not completly true, see below)
  /// [DocumentSection(id: 'foo', subsections: []),
  /// DocumentSection(id: 'sub-foo', subsections: []),
  /// DocumentSection(id: 'bar', subsections: []),];
  /// print(_allSectionsFlattend);
  /// ```
  /// The example for `print(_allSectionsFlattend);` is not completly true to
  /// the example since we don't remove the subsections after flattening the
  /// list (`foo` would still have the subsection `sub-foo` like in
  /// `allDocumentSections`).
  List<DocumentSection> _allSectionsFlattend;

  final _currentlyReadingHeadingNotifier =
      ValueNotifier<DocumentSectionId>(null);

  ValueListenable<DocumentSectionId> get currentlyReadDocumentSectionOrNull =>
      _currentlyReadingHeadingNotifier;

  CurrentlyReadingSectionController(
    this._tocSectionHeadings,
    this._visibleSectionHeadings,
  ) {
    _visibleSectionHeadings.addListener(() {
      _updateCurrentlyReadSection(_visibleSectionHeadings.value);
    });
    _allSectionsFlattend = _tocSectionHeadings
        .expand((element) => [element, ...element.subsections])
        .toList();
  }

  /// The last non-null section that we see / have seen at the top of the page.
  /// Can be null if we haven't seen any sections so far.
  ///
  /// E.g. if we have:
  /// ```
  /// ## Foo
  /// This is the Foo section.
  /// ## Bar
  /// This is the Bar section.
  /// ```
  /// then [_lastSeenTopmostVisibleSectionHeader] would equal the Foo document
  /// section.
  ///
  /// Since [_lastSeenTopmostVisibleSectionHeader] includes the last position of
  /// the section we can see if it was scrolled out the viewport in the top or
  /// at the bottom by looking at
  /// [DocumentSectionHeadingPosition.itemLeadingEdge] or
  /// [DocumentSectionHeadingPosition.itemTrailingEdge]. (See
  /// [_updateCurrentlyReadSection]).
  DocumentSectionHeadingPosition _lastSeenTopmostVisibleSectionHeader;

  void _updateCurrentlyReadSection(
      List<DocumentSectionHeadingPosition> visibleHeadings) {
    visibleHeadings
        .sort((a, b) => a.itemLeadingEdge.compareTo(b.itemLeadingEdge));

    final firstVisibleHeading =
        visibleHeadings.isNotEmpty ? visibleHeadings.first : null;
    // No Heading visible
    if (firstVisibleHeading == null) {
      // We have never seen any heading.
      if (_lastSeenTopmostVisibleSectionHeader == null) {
        return;
      }
      // We are inside a section but see no header.
      // This can happen if there is a big amount of text between sections.

      // If the last seen header was scrolled out of the viewport at the top
      // this means that we scrolled down the page.
      // Thus we are inside the text section of the last seen header.
      if (_lastSeenTopmostVisibleSectionHeader.itemLeadingEdge <= 0.5) {
        _markAsCurrentlyReading(
            _lastSeenTopmostVisibleSectionHeader.documentSection);
      }

      // If the last seen header was scrolled out of the viewport at the bottom
      // this means that we scrolled up the page.
      // Thus we are inside the section of the header that comes next if we keep
      // scrolling up.
      else {
        final _lastIndex = _indexOf(_lastSeenTopmostVisibleSectionHeader);

        // TODO: Last currently read section should be marked as read?
        // At least for small headers?

        // Unknown Heading - A heading is visible thats not inside our predefined
        // list. Doesn't necessary need to be an error since we might not want to
        // show all headings inside our TOC (e.g. the first `#` heading or very
        // small headings like `####`).
        // No section should be marked as currently read.
        if (_lastIndex == -1) {
          _markNoSectionIsCurrentlyRead();
          return;
        }

        // We scrolled above the first section.
        // No section should be marked as currently read.
        if (_lastIndex == 0) {
          _markNoSectionIsCurrentlyRead();
          return;
        }

        final sectionBefore = _allSectionsFlattend[_lastIndex - 1];

        _markAsCurrentlyReading(sectionBefore);
      }
      return;
    }

    _lastSeenTopmostVisibleSectionHeader = firstVisibleHeading;

    final firstVisibleHeadingIndex = _indexOf(firstVisibleHeading);

    // Unknown Heading - A heading is visible thats not inside our predefined
    // list. Doesn't necessary need to be an error since we might not want to
    // show all headings inside our TOC (e.g. the first `#` heading or very
    // small headings like `####`).
    // No section should be marked as currently read.
    if (firstVisibleHeadingIndex == -1) {
      _markNoSectionIsCurrentlyRead();
      return;
    }

    // If the first section is visible then mark no section as currently read
    // since if we still see the first section we haven't "entered" it.
    if (firstVisibleHeadingIndex == 0) {
      _markNoSectionIsCurrentlyRead();
      return;
    }

    final sectionBeforeTopmostVisibleHeading =
        _allSectionsFlattend[firstVisibleHeadingIndex - 1];
    _markAsCurrentlyReading(sectionBeforeTopmostVisibleHeading);
  }

  int _indexOf(DocumentSectionHeadingPosition headerPosition) {
    return _allSectionsFlattend.indexWhere(
        (pos) => pos.sectionId == headerPosition.documentSection.sectionId);
  }

  void _markAsCurrentlyReading(DocumentSection _section) {
    _currentlyReadingHeadingNotifier.value =
        _section.sectionId.toDocumentSectionIdOrNull();
  }

  void _markNoSectionIsCurrentlyRead() {
    _currentlyReadingHeadingNotifier.value = null;
  }
}

extension on String {
  DocumentSectionId toDocumentSectionIdOrNull() {
    if (this == null) {
      return null;
    }
    return DocumentSectionId(this);
  }
}
