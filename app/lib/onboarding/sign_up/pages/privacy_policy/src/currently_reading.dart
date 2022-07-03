import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

import 'privacy_policy_src.dart';

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

  /// The state of the heading that was last seen.
  /// This is set when we scroll the only heading on the screen outside the view
  /// so that no heading is visible anymore.
  ///
  /// This is needed so we can compute where in which section we are even when
  /// we see not section headings currently.
  _HeadingState _lastSeenHeadingState;

  void _updateCurrentlyReadSection(
      List<DocumentSectionHeadingPosition> visibleHeadings,
      List<DocumentSectionHeadingPosition> oldVisibleHeadings) {
    assert(oldVisibleHeadings != null);

    // If we see no section headings on screen we save what heading was last
    // seen. Later we can use that so we know what section we're currently in.
    //
    // Seeing no section heading can happen if we e.g. scroll inside a section
    // with more text than can be displayed on the screen at once.
    if (visibleHeadings.isEmpty && oldVisibleHeadings.isNotEmpty) {
      // Realistically there should only ever be a single heading but we use
      // .first for safety if that doesn't hold true.
      assert(oldVisibleHeadings.length == 1);
      final lastVisible = oldVisibleHeadings.first;

      _lastSeenHeadingState = lastVisible.itemLeadingEdge <= _threshold
          ? _HeadingState(
              documentSection: lastVisible.documentSection,
              scrolledOutAt: _ScrolledOut.atTheTop,
            )
          : _HeadingState(
              documentSection: lastVisible.documentSection,
              scrolledOutAt: _ScrolledOut.atTheBottom,
            );
    }

    // Sort so that the top-most section on screen is first in list
    visibleHeadings
        .sort((a, b) => a.itemLeadingEdge.compareTo(b.itemLeadingEdge));

    // If we see no section headings on screen...
    if (visibleHeadings.isEmpty) {
      // ...and we saved what happend with the last section on screen...
      if (_lastSeenHeadingState != null) {
        // ... we find the index of the last section on screen...
        final index = _allSectionsFlattend.indexWhere((section) =>
            section.documentSectionId ==
            _lastSeenHeadingState.documentSection.documentSectionId);

        if (index == -1) {
          throw ArgumentError(
              "Can't find section with id ${_lastSeenHeadingState.documentSection.documentSectionId} inside allSectionsFlattend ($_allSectionsFlattend)");
        }

        // ... and compute what section we're currently in:

        // Special case: We scrolled above the first section.
        if (index == 0 &&
            _lastSeenHeadingState.scrolledOutAt == _ScrolledOut.atTheBottom) {
          _markAsCurrentlyReading(null);
          return;
        }

        if (_lastSeenHeadingState.scrolledOutAt == _ScrolledOut.atTheTop) {
          _markAsCurrentlyReading(_allSectionsFlattend[index]);
        } else if (_lastSeenHeadingState.scrolledOutAt ==
            _ScrolledOut.atTheBottom) {
          _markAsCurrentlyReading(_allSectionsFlattend[index - 1]);
        } else {
          throw UnimplementedError();
        }
      }

      return;
    }

    // Sections that intersect with or are above the threshold
    final insideThreshold = visibleHeadings
        .where((section) => section.itemLeadingEdge <= _threshold);

    // If no section headings are inside the threshold...
    if (insideThreshold.isEmpty) {
      // ... we get the index of the top-most section heading on screen...
      final index = _indexOf(visibleHeadings.first);

      // Special case: If it's the first section we mark no section as currently
      // read since we haven't "entered" the first section since it's below
      // the threshold.
      if (index == 0) {
        _markAsCurrentlyReading(null);
        return;
      }

      // ... and mark the section before it as currently read (since our current
      // section is below the threshold):
      _markAsCurrentlyReading(
        _allSectionsFlattend[index - 1],
      );
      return;
    }

    // If there are section headings inside the threshold we just mark the one
    // that is closest to the threshold as currently read:
    final closest = insideThreshold.last;
    _markAsCurrentlyReading(closest.documentSection);
  }

  int _indexOf(DocumentSectionHeadingPosition headerPosition) {
    return _allSectionsFlattend.indexWhere(
        (pos) => pos.sectionId == headerPosition.documentSection.sectionId);
  }

  void _markAsCurrentlyReading(DocumentSection _section) {
    _currentlyReadingHeadingNotifier.value =
        _section?.sectionId?.toDocumentSectionIdOrNull();
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

// TODO: Can we replace this with extended enum?
class _HeadingState {
  final DocumentSection documentSection;
  final _ScrolledOut scrolledOutAt;

  _HeadingState({
    @required this.documentSection,
    @required this.scrolledOutAt,
  });
}

enum _ScrolledOut { atTheTop, atTheBottom }
