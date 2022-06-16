import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/new_privacy_policy_page.dart';

class _SectionExpansionController {
  // TODO: Should probably be a model class not views.
  final ValueListenable<List<TocDocumentSectionView>> _currentViews;
  final List<DocumentSection> _documentSections;
  final ValueListenable<DocumentSectionId> _currentlyRead;

  final _manuallyExpandedSectionId = <DocumentSectionId>{};
  final _manuallyCollapsedSectionId = <DocumentSectionId>{};

  _SectionExpansionController(
    this._currentViews,
    this._documentSections,
    this._currentlyRead,
  );

  DocumentSection _getSectionOrThrow(DocumentSectionId sectionId) {
    return _documentSections.singleWhere(
        (element) => element.documentSectionId == sectionId,
        orElse: () =>
            throw ArgumentError("Unknown $DocumentSectionId $sectionId."));
  }

  TocDocumentSectionView _getSectionViewOrThrow(DocumentSectionId sectionId) {
    return _currentViews.value.singleWhere((element) => element.id == sectionId,
        orElse: () =>
            throw ArgumentError("Unknown $DocumentSectionId $sectionId."));
  }

  void toggleExpansion(DocumentSectionId sectionId) {
    // TODO: Write tests for ArgumentError
    final sectionToToggle = _getSectionViewOrThrow(sectionId);
    if (!sectionToToggle.isExpandable)
      throw ArgumentError('$sectionId is not expandable.');

    if (sectionToToggle.isExpanded) {
      final isManuallyExpanded = _manuallyExpandedSectionId.contains(sectionId);
      if (isManuallyExpanded) {
        _manuallyExpandedSectionId.remove(sectionId);
      }
      _manuallyCollapsedSectionId.add(sectionId);
    } else {
      final isManuallyCollapsed =
          _manuallyExpandedSectionId.contains(sectionId);
      if (isManuallyCollapsed) {
        _manuallyCollapsedSectionId.remove(sectionId);
      }
      _manuallyExpandedSectionId.add(sectionId);
    }
  }

  bool isExpanded(DocumentSectionId sectionId) {
    final documentSection = _getSectionOrThrow(sectionId);

    // TODO: this is currently reading is duplicated from the toc controller.
    // We should probably use domain models that have this as a attribute
    // instead of duplicating the logic.
    final isCurrentlyReading =
        _currentlyRead.value == documentSection.documentSectionId;
    final isThisOrSubsectionCurrentlyRead = isCurrentlyReading ||
        documentSection.subsections
            .where(
                (section) => section.documentSectionId == _currentlyRead.value)
            .isNotEmpty;

    bool shouldExpandSubsections = false;
    if (documentSection.subsections.isNotEmpty) {
      final shouldAutomaticallyExpand = isThisOrSubsectionCurrentlyRead;
      final isManuallyExpanded = _manuallyExpandedSectionId
          .contains(documentSection.documentSectionId);
      bool isManuallyCollapsed = _manuallyCollapsedSectionId
          .contains(documentSection.documentSectionId);

      if (isManuallyCollapsed && !shouldAutomaticallyExpand) {
        // If it was manually collapsed but is not currently read we reset the
        // section to its default behavior (to open automatically if currently
        // read).
        _manuallyCollapsedSectionId.remove(documentSection.documentSectionId);
        isManuallyCollapsed = false;
      }

      if (shouldAutomaticallyExpand) {
        shouldExpandSubsections = !isManuallyCollapsed;
      } else {
        shouldExpandSubsections = isManuallyExpanded;
      }
    }
    return shouldExpandSubsections;
  }
}

class TableOfContentsController extends ChangeNotifier {
  final CurrentlyReadingSectionController _activeSectionController;
  final List<DocumentSection> _allDocumentSections;
  final AnchorsController _anchorsController;
  // TODO: Can we somehow make this final?
  _SectionExpansionController _sectionExpansionController;
  List<TocDocumentSectionView> _documentSections = [];

  factory TableOfContentsController.temp({
    ValueListenable<List<DocumentSectionHeadingPosition>>
        visibleSectionHeadings,
    List<DocumentSection> allDocumentSections,
    AnchorsController anchorsController,
  }) {
    return TableOfContentsController(
      CurrentlyReadingSectionController(
        allDocumentSections,
        visibleSectionHeadings,
      ),
      allDocumentSections,
      anchorsController,
    );
  }

  TableOfContentsController(
    this._activeSectionController,
    this._allDocumentSections,
    this._anchorsController,
  ) {
    final notifier = ValueNotifier<List<TocDocumentSectionView>>([]);
    addListener(() {
      notifier.value = documentSections;
    });
    _sectionExpansionController = _SectionExpansionController(
        notifier,
        _allDocumentSections,
        _activeSectionController.currentlyReadDocumentSectionOrNull);
    _updateTocDocumentSections();
    _activeSectionController.currentlyReadDocumentSectionOrNull.addListener(() {
      _updateTocDocumentSections();
    });
  }

  void _updateTocDocumentSections() {
    final currentlyReadSection =
        _activeSectionController.currentlyReadDocumentSectionOrNull.value;

    final views = _allDocumentSections
        .map((section) => _toView(section, currentlyReadSection))
        .toList();
    _documentSections = views;
    notifyListeners();
  }

  TocDocumentSectionView _toView(
      DocumentSection documentSection, DocumentSectionId isCurrentlyReading) {
    final subsections = documentSection.subsections
        .map((section) => TocDocumentSectionView(
              id: DocumentSectionId(section.sectionId),
              sectionHeadingText: section.sectionName,
              shouldHighlight:
                  DocumentSectionId(section.sectionId) == isCurrentlyReading,
              // Currently we only render the top level document sections and
              // their subsections. We don't render the subsections of
              // subsections so we just set it to an empty list.
              subsections: [],
              // Since we don't display subsections of subsections this needs to
              // be always false here.
              isExpanded: false,
            ))
        .toList();

    final isThisOrSubsectionCurrentlyRead =
        DocumentSectionId(documentSection.sectionId) == isCurrentlyReading ||
            subsections.where((section) => section.shouldHighlight).isNotEmpty;

    return TocDocumentSectionView(
      id: DocumentSectionId(documentSection.sectionId),
      sectionHeadingText: documentSection.sectionName,
      // We highlight if this or a subsection is active
      shouldHighlight: isThisOrSubsectionCurrentlyRead,
      subsections: subsections,
      isExpanded: _sectionExpansionController
          .isExpanded(documentSection.documentSectionId),
    );
  }

  List<TocDocumentSectionView> get documentSections =>
      UnmodifiableListView(_documentSections);

  Future<void> scrollTo(DocumentSectionId documentSectionId) {
    return _anchorsController.scrollToAnchor(documentSectionId.id);
  }

  void toggleDocumentSectionExpansion(DocumentSectionId documentSectionId) {
    _sectionExpansionController.toggleExpansion(documentSectionId);

    _updateTocDocumentSections();
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
      this._tocSectionHeadings, this._visibleSectionHeadings) {
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
