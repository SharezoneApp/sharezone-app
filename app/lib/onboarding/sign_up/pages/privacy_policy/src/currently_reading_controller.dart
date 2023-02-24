// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

import 'privacy_policy_src.dart';

/// Updates which [DocumentSection] inside the user is currently reading.
/// Used by the [TableOfContentsController] to highlight the currently read
/// document section.
///
/// This is done by looking at what [DocumentSection] headings (e.g.
/// `## Foo Heading`) are/were inside the viewport and working out where the
/// user is currently inside the text.
class CurrentlyReadingController {
  final _currentlyReadingHeadingNotifier =
      ValueNotifier<DocumentSectionId>(null);
  ValueListenable<DocumentSectionId> get currentlyReadDocumentSectionOrNull =>
      _currentlyReadingHeadingNotifier;

  _CurrentlyReadingState _currentState;

  CurrentlyReadingController({
    @required DocumentController documentController,
    @required PrivacyPolicy privacyPolicy,
    @required PrivacyPolicyPageConfig config,
  }) {
    final threshold = config.threshold;
    final endSectionId = config.endSection.sectionId;
    final sortedSectionHeadings = documentController.sortedSectionHeadings;

    final sectionAndSubsectionIds = privacyPolicy.tableOfContentSections
        .expand((element) => [element, ...element.subsections])
        .map((e) => e.id)
        .toIList();

    _currentState = _CurrentlyReadingState(
      tocSections: sectionAndSubsectionIds,
      endOfDocumentSectionId: endSectionId,
      viewport: _Viewport(
        sortedHeadingPositions: sortedSectionHeadings.value,
        threshold: threshold,
      ),
    );

    sortedSectionHeadings.addListener(() {
      _currentState = _currentState.updateViewport(_Viewport(
        sortedHeadingPositions: sortedSectionHeadings.value,
        threshold: threshold,
      ));

      _currentlyReadingHeadingNotifier.value =
          _currentState.currentlyReadSectionOrNull;
    });
  }
}

class _CurrentlyReadingState {
  final IList<DocumentSectionId> tocSections;

  /// Viewport with only known headings.
  ///
  /// We filter out all headings which are not inside [tocSections] or equal to
  /// [endOfDocumentSectionId] so that we can keep the logic in this class
  /// simpler.
  ///
  /// From a UX perspective we want to ignore unknown headings since it would be
  /// confusing if a user scrolls past a unknown heading and suddendly no
  /// section is marked as currently read inside the table of contents anymore.
  final _Viewport filteredViewport;

  /// The [DocumentSectionId] that is at the very end of the privacy policy.
  /// It is used to see if the user has reached the bottom of the document.
  ///
  /// We use this workaround since we can't access the `ScrollController` of the
  /// privacy policy text to look at the the scroll position / offset.
  /// This is because the privacy policy text widget uses
  /// `ScrollablePositionedList` which doesn't expose its internal
  /// `ScrollController`.
  final DocumentSectionId endOfDocumentSectionId;

  /// Saves the [_HeadingState] of the last heading seen on screen after we call
  /// [updateViewport] with a [_Viewport] where [_Viewport.noHeadingsVisible] is
  /// true.
  ///
  /// Basically if we scroll out the last heading on screen we need to know if
  /// we scrolled it out the top or bottom of the page so that we can compute
  /// which section we are currently reading even though no headings are visible
  /// anymore.
  final _HeadingState lastSeenHeadingState;

  factory _CurrentlyReadingState({
    @required IList<DocumentSectionId> tocSections,
    @required _Viewport viewport,
    @required DocumentSectionId endOfDocumentSectionId,
  }) {
    final noUnknwonHeadings = viewport.removeUnknownHeadings(
        knownHeadings: IList([...tocSections, endOfDocumentSectionId]));

    return _CurrentlyReadingState._(
      tocSections: tocSections,
      filteredViewport: noUnknwonHeadings,
      endOfDocumentSectionId: endOfDocumentSectionId,
      lastSeenHeadingState: null,
    );
  }

  _CurrentlyReadingState._({
    @required this.tocSections,
    @required this.filteredViewport,
    @required this.endOfDocumentSectionId,
    @required this.lastSeenHeadingState,
  }) : assert(() {
          // We assume that we already filtered out all headings that are
          // unknown to us.
          // See documentation of [viewport] property.
          final viewportContainsOnlyKnownHeadings =
              filteredViewport.sortedHeadingPositions.every((element) =>
                  tocSections.contains(element.documentSectionId) ||
                  element.documentSectionId == endOfDocumentSectionId);

          return viewportContainsOnlyKnownHeadings;
        }());

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

  // TODO: See if we can make the doc comments read more smoothly with the edge
  // cases in between
  DocumentSectionId _computeCurrentlyRead() {
    final viewport = filteredViewport;

    // If we see no section headings on screen...
    if (viewport.noHeadingsVisible) {
      // ...and we saved what happend with the last section on screen...
      if (lastSeenHeadingState != null) {
        // ... we find the index of the last section on screen...
        final sections = [...tocSections, endOfDocumentSectionId];
        final index = sections
            .indexWhere((section) => section == lastSeenHeadingState.id);

        if (index == -1) {
          throw StateError(
              "Can't find section with id ${lastSeenHeadingState.id} inside TOC sections + end section ($sections). This is an developer error and needs to be fixed. Viewport: $viewport, endOfDocumentSectionId: $endOfDocumentSectionId, lastSeenHeadingState: $lastSeenHeadingState.");
        }

        // ... and compute what section we're currently in:

        // Special case: We scrolled above the first section.
        if (index == 0 &&
            lastSeenHeadingState.scrolledOutAt == _ScrolledOut.atTheBottom) {
          return null;
        }

        // Special case: We scrolled past the special end section (
        // realistically it shouldn't be big enough for that to happen but who
        // knows).
        if (lastSeenHeadingState.id == endOfDocumentSectionId &&
            lastSeenHeadingState.scrolledOutAt == _ScrolledOut.atTheTop) {
          return tocSections.last;
        }

        if (lastSeenHeadingState.scrolledOutAt == _ScrolledOut.atTheTop) {
          return tocSections[index];
        } else if (lastSeenHeadingState.scrolledOutAt ==
            _ScrolledOut.atTheBottom) {
          return tocSections[index - 1];
        } else {
          throw UnimplementedError();
        }
      }

      // Never seen a section on screen.
      return null;
    }

    // Special case: We see the document section that signals to us that the
    // user reached the bottom of the document.
    final pos = viewport.getFirstPositionOfOrNull(endOfDocumentSectionId);
    if (pos != null) {
      // We mark the last section in our table of contents as currently read
      // (will probably not be the same as [_endOfDocumentSectionId]).
      // For more info see docs of [_endOfDocumentSectionId].
      return tocSections.last;
    }

    // Sections that intersect with or are above the threshold
    final insideThreshold = viewport.sectionsInThreshold;

    // If no section headings are inside the threshold...
    if (insideThreshold.isEmpty) {
      // ... we get the index of the top-most section heading on screen...
      final index = _indexOf(viewport.sortedHeadingPositions.first);

      if (index == -1) {
        throw StateError(
            'Index of viewport.sortedHeadingPositions.first was -1. This is unexpected, a developer error and should be fixed. Viewport: $viewport, endOfDocumentSectionId: $endOfDocumentSectionId, lastSeenHeadingState: $lastSeenHeadingState');
      }

      // Special case: If it's the first section we mark no section as currently
      // read since we haven't "entered" the first section since it's below
      // the threshold.
      if (index == 0) {
        return null;
      }

      // ... and mark the section before it as currently read (since our current
      // section is below the threshold):
      return tocSections[index - 1];
    }

    // If there are section headings inside the threshold we just mark the one
    // that is closest to the threshold as currently read:
    return viewport.closestToThresholdOrNull?.documentSectionId;
  }

  int _indexOf(DocumentSectionHeadingPosition headerPosition) {
    return tocSections
        .indexWhere((pos) => pos == headerPosition.documentSectionId);
  }

  _CurrentlyReadingState updateViewport(_Viewport updatedViewport) {
    final filteredUpdatedViewport = updatedViewport.removeUnknownHeadings(
        knownHeadings: IList([...tocSections, endOfDocumentSectionId]));

    // If we see no section headings on screen we save what heading was last
    // seen. Later we can use that so we know what section we're currently in.
    //
    // Seeing no section heading can happen if we e.g. scroll inside a section
    // with more text than can be displayed on the screen at once.
    if (filteredViewport.headingsVisible &&
        filteredUpdatedViewport.noHeadingsVisible) {
      // Realistically there should only ever be a single heading but when
      // scrolling really fast it can happen that several headings disappear
      // together.
      final lastVisible = filteredViewport.sortedHeadingPositions.first;

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
        filteredViewport: filteredUpdatedViewport,
        lastSeenHeadingState: newLastSeenHeadingState,
      );
    }
    return _copyWith(
      filteredViewport: filteredUpdatedViewport,
    );
  }

  _CurrentlyReadingState _copyWith({
    IList<DocumentSectionId> tocSections,
    _Viewport filteredViewport,
    _HeadingState lastSeenHeadingState,
  }) {
    return _CurrentlyReadingState._(
      endOfDocumentSectionId: endOfDocumentSectionId,
      filteredViewport: filteredViewport ?? this.filteredViewport,
      tocSections: tocSections ?? this.tocSections,
      lastSeenHeadingState: lastSeenHeadingState ?? this.lastSeenHeadingState,
    );
  }
}

class _Viewport {
  final IList<DocumentSectionHeadingPosition> sortedHeadingPositions;
  final CurrentlyReadThreshold threshold;

  const _Viewport({
    @required this.sortedHeadingPositions,
    @required this.threshold,
  });

  /// Remove all headings which are not inside [knownHeadings].
  /// More details inside [_CurrentlyReadingState.viewport].
  _Viewport removeUnknownHeadings(
      {@required IList<DocumentSectionId> knownHeadings}) {
    return _Viewport(
      sortedHeadingPositions: sortedHeadingPositions
          .where((element) => knownHeadings.contains(element.documentSectionId))
          .toIList(),
      threshold: threshold,
    );
  }

  bool get headingsVisible => !noHeadingsVisible;
  bool get noHeadingsVisible => sortedHeadingPositions.isEmpty;

  DocumentSectionHeadingPosition get closestToThresholdOrNull {
    return sectionsInThreshold.last;
  }

  IList<DocumentSectionHeadingPosition> get sectionsInThreshold {
    // Since [sortedHeadingPositions] includes only headings that are currently
    // drawn we don't return all the headings that we already scrolled off the
    // screen.
    return sortedHeadingPositions
        .where((section) => threshold.intersectsOrIsPast(section))
        .toIList();
  }

  DocumentSectionHeadingPosition getFirstPositionOfOrNull(
      DocumentSectionId documentSectionId) {
    return sortedHeadingPositions.firstWhere(
        (element) => element.documentSectionId == documentSectionId,
        orElse: () => null);
  }

  @override
  String toString() =>
      '_Viewport(sortedHeadingPositions: $sortedHeadingPositions, threshold: $threshold)';
}

// TODO: Can we replace this with extended enum?
class _HeadingState {
  final DocumentSectionId id;
  final _ScrolledOut scrolledOutAt;

  _HeadingState({
    @required this.id,
    @required this.scrolledOutAt,
  });

  @override
  String toString() => '_HeadingState(id: $id, scrolledOutAt: $scrolledOutAt)';
}

enum _ScrolledOut { atTheTop, atTheBottom }
