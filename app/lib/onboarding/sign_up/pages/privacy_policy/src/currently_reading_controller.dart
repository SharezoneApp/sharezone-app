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
  ///
  /// It is used to see if the user has reached the bottom of the document.
  ///
  /// We use this workaround since we can't access the `ScrollController` of the
  /// privacy policy text to look at the the scroll position / offset.
  /// This is because the privacy policy text widget uses
  /// `ScrollablePositionedList` which doesn't expose its internal
  /// `ScrollController`:
  /// https://github.com/google/flutter.widgets/issues/235
  ///
  /// For more info see documentation of [PrivacyPolicyEndSection].
  final DocumentSectionId endOfDocumentSectionId;

  /// State of last heading seen on screen.
  ///
  /// Saves the [_HeadingState] of the last heading seen in the [_Viewport] if
  /// we currently see headings and [updateViewport] is called with a new
  /// [_Viewport] where [_Viewport.noHeadingsVisible] is `true`.
  ///
  /// If we scroll out the last heading on screen we need to know if we scrolled
  /// it out the top or bottom of the page so that we can compute which section
  /// we are currently reading even though no headings are visible anymore.
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

  DocumentSectionId _computeCurrentlyRead() {
    final viewport = filteredViewport;

    // If we see no section headings on screen...
    if (viewport.noHeadingsVisible) {
      // ...and we saved what happend with the last heading on screen...
      if (lastSeenHeadingState != null) {
        // ... we find the index of the last heading on screen...
        final sectionHeadingIds = [...tocSections, endOfDocumentSectionId];
        final index = sectionHeadingIds
            .indexWhere((section) => section == lastSeenHeadingState.id);

        if (index == -1) {
          throw StateError(
              "Can't find section with id ${lastSeenHeadingState.id} inside TOC sections + end section ($sectionHeadingIds). This is an developer error and needs to be fixed. Viewport: $viewport, endOfDocumentSectionId: $endOfDocumentSectionId, lastSeenHeadingState: $lastSeenHeadingState.");
        }

        // ... and compute what section we're currently in:

        // If we scrolled above the first section heading then no section is
        // currently read.
        if (index == 0 &&
            lastSeenHeadingState.scrolledOutAt == _ScrolledOut.atTheBottom) {
          return null;
        }

        // If we scrolled past the special end section heading then the last
        // section of the toc is currently read.
        // (Realistically the end section shouldn't be big enough to scroll past
        // the heading but who knows).
        if (lastSeenHeadingState.id == endOfDocumentSectionId &&
            lastSeenHeadingState.scrolledOutAt == _ScrolledOut.atTheTop) {
          return tocSections.last;
        }

        // If the last seen heading was scrolled out at the top then the
        // currently read section is the one "below" it.
        if (lastSeenHeadingState.scrolledOutAt == _ScrolledOut.atTheTop) {
          return tocSections[index];
        }

        // If the last seen heading was scrolled out at the bottom then the
        // currently read section is the one "above" it.
        if (lastSeenHeadingState.scrolledOutAt == _ScrolledOut.atTheBottom) {
          return tocSections[index - 1];
        }

        // Isn't reachable.
        // We used isolated "if"s to make the code more readable, but this will
        // make the linter complain that we didn't cover all cases without this.
        throw UnimplementedError();
      }

      // We've never seen a section heading on screen, thus no section is
      // currently read.
      return null;
    }

    // We see section headings on-screen:

    // We see the special "end of document" section heading that signals to us
    // that the user has reached (more or less) the bottom of the document.
    final pos = viewport.getFirstPositionOfOrNull(endOfDocumentSectionId);
    if (pos != null) {
      // We mark the last section in our table of contents as currently read
      // (which will most likely not be the same as [endOfDocumentSectionId]).
      // For more infos for this behavior see the docs of
      // [endOfDocumentSectionId].
      return tocSections.last;
    }

    // Section headings that intersect with or are inside the threshold
    final insideThreshold = viewport.sectionsInThreshold;

    // If no section headings are inside the threshold...
    if (insideThreshold.isEmpty) {
      // ... we get the index of the top-most section heading on screen.
      final index = _indexOf(viewport.sortedHeadingPositions.first);

      if (index == -1) {
        throw StateError(
            'Index of viewport.sortedHeadingPositions.first was -1. This is unexpected, a developer error and should be fixed. Viewport: $viewport, endOfDocumentSectionId: $endOfDocumentSectionId, lastSeenHeadingState: $lastSeenHeadingState');
      }

      // If it's the first toc section then we mark no section as currently read
      // (since it hasn't passed the threshold yet).
      if (index == 0) {
        return null;
      }

      // Otherwise we mark the section that is "above" or before the current
      // section as currently read.
      return tocSections[index - 1];
    }

    // If there are one or multiple headings inside the threshold we mark the
    // one closest to the start of the threshold as currently read.
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
      final sortedHeadings = filteredViewport.sortedHeadingPositions;

      // Simple heuristic: If the last heading we've seen was in the upper half
      // of the viewport before calling updateViewport then it was scrolled out
      // at the top otherwise at the bottom.
      final newLastSeenHeadingState = sortedHeadings.first.itemLeadingEdge < .5
          ? _HeadingState(
              // If we scroll out multiple headings out the top then we use the
              // lower one as "last seen".
              id: sortedHeadings.last.documentSectionId,
              scrolledOutAt: _ScrolledOut.atTheTop,
            )
          : _HeadingState(
              // If we scroll out multiple headings out the bottom then we use
              // the upper one as "last seen".
              id: sortedHeadings.first.documentSectionId,
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
