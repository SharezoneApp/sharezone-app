import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

import 'privacy_policy_src.dart';

class _ReadingState {
  final DocumentSection documentSection;
  final _ScrolledOut state;

  _ReadingState({
    @required this.documentSection,
    @required this.state,
  });
}

enum _ScrolledOut { atTheTop, atTheBottom }

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
  // TODO: Better name?
  final double _threshold;

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

  List<DocumentSectionHeadingPosition> _oldVisibleHeadings;

  CurrentlyReadingSectionController(
    this._tocSectionHeadings,
    this._visibleSectionHeadings, {
    // TODO: Maybe make required?
    double threshold = 0.1,
  }) : _threshold = threshold {
    _oldVisibleHeadings = _visibleSectionHeadings.value ?? [];
    _visibleSectionHeadings.addListener(() {
      _updateCurrentlyReadSection(
          _visibleSectionHeadings.value, _oldVisibleHeadings);
      _oldVisibleHeadings = _visibleSectionHeadings.value;
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

  _ReadingState _readingState;

  void _updateCurrentlyReadSection(
      List<DocumentSectionHeadingPosition> visibleHeadings,
      List<DocumentSectionHeadingPosition> oldVisibleHeadings) {
    assert(oldVisibleHeadings != null);
    final _visibleHeadings = visibleHeadings.toIList();

    if (visibleHeadings.isEmpty && oldVisibleHeadings.isNotEmpty) {
      // Realistically there should only ever be a single heading before (so
      // visibleHeadings.single should work instead of visibleHeadings.first).
      final lastVisible = oldVisibleHeadings.first;
      _readingState = lastVisible.itemLeadingEdge <= _threshold
          ? _ReadingState(
              documentSection: lastVisible.documentSection,
              state: _ScrolledOut.atTheTop,
            )
          : _ReadingState(
              documentSection: lastVisible.documentSection,
              state: _ScrolledOut.atTheBottom,
            );
    }

    if (visibleHeadings.isEmpty) {
      if (_readingState != null) {
        // TODO: index == -1
        final index = _allSectionsFlattend
            .indexWhere((element) => element == _readingState.documentSection);

        if (index == 0 && _readingState.state == _ScrolledOut.atTheBottom) {
          _markNoSectionIsCurrentlyRead();
          return;
        }
        if (_readingState.state == _ScrolledOut.atTheTop) {
          _markAsCurrentlyReading(_allSectionsFlattend[index]);
        } else if (_readingState.state == _ScrolledOut.atTheBottom) {
          _markAsCurrentlyReading(_allSectionsFlattend[index - 1]);
        } else {
          throw UnimplementedError();
        }
      }

      return;
    }

    // Sections that intersect or are above the threshold
    final insideThreshold = _visibleHeadings
        .where((section) => section.itemLeadingEdge <= _threshold)
        .toIList();

    if (insideThreshold.isEmpty) {
      final index = _indexOf(_visibleHeadings
          .sort((a, b) => a.itemLeadingEdge.compareTo(b.itemLeadingEdge))
          .first);

      if (index == 0) {
        _markNoSectionIsCurrentlyRead();
        return;
      }

      _markAsCurrentlyReading(
        _allSectionsFlattend[index - 1],
      );
      return;
    }

    final closest = insideThreshold
        .sort((a, b) => a.itemLeadingEdge.compareTo(b.itemLeadingEdge))
        .last;

    final heading = closest;

    _markAsCurrentlyReading(heading.documentSection);
  }

  void _updateCurrentlyReadSectionOld(
      List<DocumentSectionHeadingPosition> visibleHeadings) {
    visibleHeadings
        .sort((a, b) => a.itemLeadingEdge.compareTo(b.itemLeadingEdge));

    final visibleAfterThreshold = visibleHeadings
        .where((heading) => heading.itemLeadingEdge <= _threshold);

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
      if (_lastSeenTopmostVisibleSectionHeader.itemLeadingEdge <= _threshold) {
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
    // if (firstVisibleHeadingIndex == 0) {
    //   _markNoSectionIsCurrentlyRead();
    //   return;
    // }
    if (firstVisibleHeadingIndex == 0) {
      _markAsCurrentlyReading(_allSectionsFlattend[0]);
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
