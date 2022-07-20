// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

import '../privacy_policy_src.dart';

/// Updates which [DocumentSection] inside the table of contents the user is
/// currently reading.
///
/// This is done by looking at what [DocumentSection] headings (e.g.
/// `## Foo Heading`) are/were inside the viewport and working out where the
/// user is currently inside the text.
class CurrentlyReadingSectionController {
  final _currentlyReadingHeadingNotifier =
      ValueNotifier<DocumentSectionId>(null);
  ValueListenable<DocumentSectionId> get currentlyReadDocumentSectionOrNull =>
      _currentlyReadingHeadingNotifier;

  _CurrentlyReadingState _currentState;

  CurrentlyReadingSectionController(
    List<DocumentSection> tableOfContentsDocumentSections,
    ValueListenable<List<DocumentSectionHeadingPosition>>
        visibleSectionHeadings, {
    @required DocumentSectionId endOfDocumentSectionId,
    // TODO: Maybe make required?
    double threshold = 0.1,
  }) {
    final sectionAndSubsectionIds = tableOfContentsDocumentSections
        .expand((element) => [element, ...element.subsections])
        .map((e) => e.documentSectionId)
        .toList();

    _currentState = _CurrentlyReadingState(
      tocSections: sectionAndSubsectionIds,
      endOfDocumentSectionId: endOfDocumentSectionId,
      viewport: _Viewport(
        headingPositions: visibleSectionHeadings.value.toIList(),
        threshold: threshold,
      ),
    );

    visibleSectionHeadings.addListener(() {
      _currentState = _currentState.viewportWasUpdated(
        _Viewport(
          headingPositions: visibleSectionHeadings.value.toIList(),
          threshold: threshold,
        ),
      );

      _currentlyReadingHeadingNotifier.value =
          _currentState.currentlyReadSectionOrNull;
    });
  }
}

class _CurrentlyReadingState {
  final List<DocumentSectionId> _tocSections;
  final _HeadingState _lastSeenHeadingState;
  final _Viewport _viewport;
  // TODO: Document here and/or in constructor
  final DocumentSectionId _endOfDocumentSectionId;

  _CurrentlyReadingState({
    @required List<DocumentSectionId> tocSections,
    @required _Viewport viewport,
    @required DocumentSectionId endOfDocumentSectionId,
    _HeadingState lastSeenHeadingState,
  })  : _tocSections = tocSections,
        _viewport = viewport,
        _lastSeenHeadingState = lastSeenHeadingState,
        _endOfDocumentSectionId = endOfDocumentSectionId;

  DocumentSectionId _currentlyReadSectionOrNull;
  bool _isCached = false;
  DocumentSectionId get currentlyReadSectionOrNull {
    // Can't use this since _computeCurrentlyRead can return null:
    // `return _currentlyReadSectionOrNull ??= _computeCurrentlyRead();`

    if (!_isCached) {
      _currentlyReadSectionOrNull = _computeCurrentlyRead();
      _isCached = true;
    }
    return _currentlyReadSectionOrNull;
  }

  DocumentSectionId _computeCurrentlyRead() {
    // If we see no section headings on screen...
    if (_viewport.noHeadingsVisible) {
      // ...and we saved what happend with the last section on screen...
      if (_lastSeenHeadingState != null) {
        // ... we find the index of the last section on screen...
        final index = _tocSections
            .indexWhere((section) => section == _lastSeenHeadingState.id);

        // TODO: This is thrown if an unknwon heading is the only one on screen
        // and is scrolled out i think?
        // I guess unkown headings should never be saved to
        // _lastSeenHeadingState?
        if (index == -1) {
          throw ArgumentError(
              "Can't find section with id ${_lastSeenHeadingState.id} inside allSectionsFlattend ($_tocSections)");
        }

        // ... and compute what section we're currently in:

        // Special case: We scrolled above the first section.
        if (index == 0 &&
            _lastSeenHeadingState.scrolledOutAt == _ScrolledOut.atTheBottom) {
          return null;
        }

        if (_lastSeenHeadingState.scrolledOutAt == _ScrolledOut.atTheTop) {
          return _tocSections[index];
        } else if (_lastSeenHeadingState.scrolledOutAt ==
            _ScrolledOut.atTheBottom) {
          return _tocSections[index - 1];
        } else {
          throw UnimplementedError();
        }
      }

      // Never seen a section on screen.
      return null;
    }

    // Special case: We see the document section that signals to us that the
    // user reached the bottom of the document.
    final pos = _viewport.getFirstPositionOfOrNull(_endOfDocumentSectionId);
    // If the heading is completly visible in the viewport
    if (pos != null && pos.itemTrailingEdge <= 1.0) {
      // then we mark the last section in our table of contents as active
      // (will probably not be the same as [_endOfDocumentSectionId]).
      // For more info see docs of [_endOfDocumentSectionId].
      return _tocSections.last;
    }

    // Sections that intersect with or are above the threshold
    final insideThreshold = _viewport.sectionsInThreshold;

    // If no section headings are inside the threshold...
    if (insideThreshold.isEmpty) {
      // ... we get the index of the top-most section heading on screen...
      final index = _indexOf(_viewport.sortedHeadingPositions.first);

      // Special case: If it's the first section we mark no section as currently
      // read since we haven't "entered" the first section since it's below
      // the threshold.
      if (index == 0) {
        return null;
      }

      // ... and mark the section before it as currently read (since our current
      // section is below the threshold):
      return _tocSections[index - 1];
    }

    // If there are section headings inside the threshold we just mark the one
    // that is closest to the threshold as currently read:
    return _viewport.closestToThresholdOrNull?.documentSectionId;
  }

  int _indexOf(DocumentSectionHeadingPosition headerPosition) {
    return _tocSections
        .indexWhere((pos) => pos == headerPosition.documentSectionId);
  }

  _CurrentlyReadingState viewportWasUpdated(_Viewport updatedViewport) {
    // If we see no section headings on screen we save what heading was last
    // seen. Later we can use that so we know what section we're currently in.
    //
    // Seeing no section heading can happen if we e.g. scroll inside a section
    // with more text than can be displayed on the screen at once.
    if (_viewport.headingsVisible && updatedViewport.noHeadingsVisible) {
      // Realistically there should only ever be a single heading but when
      // scrolling really fast it can happen that several headings disappear
      // together.
      final lastVisible = _viewport.sortedHeadingPositions.first;

      final newLastSeenHeadingState = lastVisible.itemLeadingEdge < .5
          ? _HeadingState(
              id: lastVisible.documentSectionId,
              scrolledOutAt: _ScrolledOut.atTheTop,
            )
          : _HeadingState(
              id: lastVisible.documentSectionId,
              scrolledOutAt: _ScrolledOut.atTheBottom,
            );

      return _copyWith(
        viewport: updatedViewport,
        lastSeenHeadingState: newLastSeenHeadingState,
      );
    }
    return _copyWith(
      viewport: updatedViewport,
    );
  }

  _CurrentlyReadingState _copyWith({
    List<DocumentSectionId> tocSections,
    _Viewport viewport,
    _HeadingState lastSeenHeadingState,
  }) {
    return _CurrentlyReadingState(
      endOfDocumentSectionId: _endOfDocumentSectionId,
      viewport: viewport ?? _viewport,
      tocSections: tocSections ?? _tocSections,
      lastSeenHeadingState: lastSeenHeadingState ?? _lastSeenHeadingState,
    );
  }
}

class _Viewport {
  final IList<DocumentSectionHeadingPosition> sortedHeadingPositions;
  final double threshold;

  factory _Viewport({
    @required IList<DocumentSectionHeadingPosition> headingPositions,
    @required double threshold,
  }) {
    final sorted = headingPositions.sort(
        (pos1, pos2) => pos1.itemLeadingEdge.compareTo(pos2.itemLeadingEdge));

    return _Viewport._(
      sortedHeadingPositions: sorted,
      threshold: threshold,
    );
  }

  const _Viewport._({
    @required this.sortedHeadingPositions,
    @required this.threshold,
  });

  bool get headingsVisible => !noHeadingsVisible;
  bool get noHeadingsVisible => sortedHeadingPositions.isEmpty;

  DocumentSectionHeadingPosition get closestToThresholdOrNull {
    return sectionsInThreshold.last;
  }

  IList<DocumentSectionHeadingPosition> get sectionsInThreshold {
    return sortedHeadingPositions
        .where((section) => section.itemLeadingEdge <= threshold)
        .toIList();
  }

  DocumentSectionHeadingPosition getFirstPositionOfOrNull(
      DocumentSectionId documentSectionId) {
    return sortedHeadingPositions.firstWhere(
        (element) => element.documentSectionId == documentSectionId,
        orElse: () => null);
  }
}

// TODO: Can we replace this with extended enum?
class _HeadingState {
  final DocumentSectionId id;
  final _ScrolledOut scrolledOutAt;

  _HeadingState({
    @required this.id,
    @required this.scrolledOutAt,
  });
}

enum _ScrolledOut { atTheTop, atTheBottom }
