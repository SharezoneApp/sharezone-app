// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/new_privacy_policy_page.dart';

import 'privacy_policy_src.dart';
import 'widgets/common.dart';

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
        .map((e) => e.documentSectionId)
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
      _currentState = _currentState.updateViewport(
        _Viewport(
          sortedHeadingPositions: sortedSectionHeadings.value,
          threshold: threshold,
        ),
      );

      _currentlyReadingHeadingNotifier.value =
          _currentState.currentlyReadSectionOrNull;
    });
  }
}

class _CurrentlyReadingState {
  final IList<DocumentSectionId> tocSections;
  final _Viewport viewport;

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

  _CurrentlyReadingState({
    @required this.tocSections,
    @required this.viewport,
    @required this.endOfDocumentSectionId,
    this.lastSeenHeadingState,
  });

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
    if (viewport.noHeadingsVisible) {
      // ...and we saved what happend with the last section on screen...
      if (lastSeenHeadingState != null) {
        // ... we find the index of the last section on screen...
        final index = tocSections
            .indexWhere((section) => section == lastSeenHeadingState.id);

        // TODO: This is thrown if an unknwon heading is the only one on screen
        // and is scrolled out i think?
        // I guess unkown headings should never be saved to
        // _lastSeenHeadingState?
        if (index == -1) {
          throw ArgumentError(
              "Can't find section with id ${lastSeenHeadingState.id} inside allSectionsFlattend ($tocSections)");
        }

        // ... and compute what section we're currently in:

        // Special case: We scrolled above the first section.
        if (index == 0 &&
            lastSeenHeadingState.scrolledOutAt == _ScrolledOut.atTheBottom) {
          return null;
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
    // If the heading is completly visible in the viewport
    if (pos != null && pos.itemTrailingEdge <= 1.0) {
      // then we mark the last section in our table of contents as active
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

      // Saw this happen once in a wrongly configured test. Shouldn't happen in
      // the real world but if it does we throw an Error to indicate it being
      // a developer error, not an user error. I don't really understand when it
      // could happen.
      if (index == -1) {
        throw StateError(
            'Index of viewport.sortedHeadingPositions.first was -1. This is unexpected, a developer error and should be fixed. viewport.sortedHeadingPositions: ${viewport.sortedHeadingPositions}');
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
    // If we see no section headings on screen we save what heading was last
    // seen. Later we can use that so we know what section we're currently in.
    //
    // Seeing no section heading can happen if we e.g. scroll inside a section
    // with more text than can be displayed on the screen at once.
    if (viewport.headingsVisible && updatedViewport.noHeadingsVisible) {
      // Realistically there should only ever be a single heading but when
      // scrolling really fast it can happen that several headings disappear
      // together.
      final lastVisible = viewport.sortedHeadingPositions.first;

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
    IList<DocumentSectionId> tocSections,
    _Viewport viewport,
    _HeadingState lastSeenHeadingState,
  }) {
    return _CurrentlyReadingState(
      endOfDocumentSectionId: endOfDocumentSectionId,
      viewport: viewport ?? this.viewport,
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
