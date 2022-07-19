// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';

import '../privacy_policy_src.dart';

/// Updates which [DocumentSection] inside the table of contents the user is
/// currently reading.
///
/// This is done by looking at what [DocumentSection] headings (e.g.
/// `## Foo Heading`) are/were inside the viewport and working out where the
/// user is currently inside the text.
class CurrentlyReadingSectionController {
  final ValueListenable<List<DocumentSectionHeadingPosition>>
      _visibleSectionHeadings;

  final DocumentSectionId bottomSectionId = DocumentSectionId('metadaten');

  final _currentlyReadingHeadingNotifier =
      ValueNotifier<DocumentSectionId>(null);

  ValueListenable<DocumentSectionId> get currentlyReadDocumentSectionOrNull =>
      _currentlyReadingHeadingNotifier;

  _PrivacyPolicyViewport _privacyPolicyViewport;

  CurrentlyReadingSectionController(
    List<DocumentSection> _tocSectionHeadings,
    this._visibleSectionHeadings, {
    // TODO: Maybe make required?
    double threshold = 0.1,
  }) {
    final sectionAndSubsectionIds = _tocSectionHeadings
        .expand((element) => [element, ...element.subsections])
        .map((e) => e.documentSectionId)
        .toList();

    _privacyPolicyViewport = _PrivacyPolicyViewport(
      tocSections: sectionAndSubsectionIds,
      headingPositions: _visibleSectionHeadings.value,
      threshold: threshold,
    );

    _visibleSectionHeadings.addListener(() {
      _privacyPolicyViewport = _privacyPolicyViewport
          .headingPositionsUpdated(_visibleSectionHeadings.value);

      // TODO: Protyped workaround, implement in a nicer way (Add to
      // _PrivacyPolicyViewport?)
      final bottomRes = _visibleSectionHeadings.value
          .where((element) => element.documentSectionId == bottomSectionId);

      if (bottomRes.isNotEmpty && bottomRes.first.itemTrailingEdge <= 1) {
        _currentlyReadingHeadingNotifier.value =
            _tocSectionHeadings.last.documentSectionId;
      } else {
        _currentlyReadingHeadingNotifier.value =
            _privacyPolicyViewport.currentlyReadSectionOrNull;
      }
    });
  }
}

class _PrivacyPolicyViewport {
  final List<DocumentSectionId> _tocSections;
  final List<DocumentSectionHeadingPosition> _headingPositions;
  final double _threshold;
  final _HeadingState _lastSeenHeadingState;

  _PrivacyPolicyViewport({
    @required List<DocumentSectionId> tocSections,
    @required List<DocumentSectionHeadingPosition> headingPositions,
    @required double threshold,
    _HeadingState lastSeenHeadingState,
  })  : _tocSections = tocSections,
        _headingPositions = headingPositions,
        _threshold = threshold,
        _lastSeenHeadingState = lastSeenHeadingState {
    // Sort so that the top-most section on screen is first in list
    _headingPositions
        .sort((a, b) => a.itemLeadingEdge.compareTo(b.itemLeadingEdge));
  }

  _PrivacyPolicyViewport headingPositionsUpdated(
      List<DocumentSectionHeadingPosition> newHeadingPositions) {
    // If we see no section headings on screen we save what heading was last
    // seen. Later we can use that so we know what section we're currently in.
    //
    // Seeing no section heading can happen if we e.g. scroll inside a section
    // with more text than can be displayed on the screen at once.
    if (newHeadingPositions.isEmpty && _headingPositions.isNotEmpty) {
      // Realistically there should only ever be a single heading but when
      // scrolling really fast it can happen that several headings disappear
      // together.
      final lastVisible = _headingPositions.first;

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
        headingPositions: newHeadingPositions,
        lastSeenHeadingState: newLastSeenHeadingState,
      );
    }
    return _copyWith(
      headingPositions: newHeadingPositions,
    );
  }

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
    if (_headingPositions.isEmpty) {
      // ...and we saved what happend with the last section on screen...
      if (_lastSeenHeadingState != null) {
        // ... we find the index of the last section on screen...
        final index = _tocSections
            .indexWhere((section) => section == _lastSeenHeadingState.id);

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

    // Sections that intersect with or are above the threshold
    final insideThreshold = _headingPositions
        .where((section) => section.itemLeadingEdge <= _threshold);

    // If no section headings are inside the threshold...
    if (insideThreshold.isEmpty) {
      // ... we get the index of the top-most section heading on screen...
      final index = _indexOf(_headingPositions.first);

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
    final closest = insideThreshold.last;
    return closest.documentSectionId;
  }

  int _indexOf(DocumentSectionHeadingPosition headerPosition) {
    return _tocSections
        .indexWhere((pos) => pos == headerPosition.documentSectionId);
  }

  _PrivacyPolicyViewport _copyWith({
    List<DocumentSectionId> tocSections,
    List<DocumentSectionHeadingPosition> headingPositions,
    double threshold,
    _HeadingState lastSeenHeadingState,
  }) {
    return _PrivacyPolicyViewport(
      headingPositions: headingPositions ?? _headingPositions,
      threshold: threshold ?? _threshold,
      tocSections: tocSections ?? _tocSections,
      lastSeenHeadingState: lastSeenHeadingState ?? _lastSeenHeadingState,
    );
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
