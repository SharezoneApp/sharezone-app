// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import '../privacy_policy_src.dart';

/// The threshold at which a [DocumentSection] is marked as "currently read"
/// when the [DocumentSectionHeadingPosition] intersects with [position].
///
/// E.g. `CurrentlyReadThreshold(0.1)` means that the section heading has to
/// be inside the top 10% of the screen to be marked as currently read.
/// `CurrentlyReadThreshold(0.0)` means that the section heading has to be
/// scrolled out of the top of the screen to be marked as currently read.
///
/// For the exact behavior for when a section is marked as active see
/// [CurrentlyReadingController] (and the tests).
///
/// This is encapsulated as a class for documentation purposes.
class CurrentlyReadThreshold {
  final double position;

  const CurrentlyReadThreshold(this.position)
      : assert(position >= 0.0 && position <= 1.0);

  bool intersectsOrIsPast(DocumentSectionHeadingPosition headingPosition) {
    return headingPosition.itemLeadingEdge <= position;
  }
}
