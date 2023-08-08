// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../privacy_policy_src.dart';

/// A model of a section (or chapter) of the markdown document.
/// Used by the table of contents to list and navigate to specific sections of
/// the privacy policy.
///
/// A section is created inside the markdown document by an headline with
/// following content:
/// ```markdown
/// # Section
/// Lorem Ipsum
/// ## Subsection
/// Bla bla bla
/// ```
///
/// This will create the following [DocumentSection]:
/// ```dart
/// DocumentSection('section', 'Section', [
///   DocumentSection('subsection', 'Subsection'),
/// ]);
/// ```
class DocumentSection {
  final DocumentSectionId id;
  final String sectionName;
  final IList<DocumentSection> subsections;

  DocumentSection(this.id, this.sectionName,
      [this.subsections = const IListConst([])]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is DocumentSection &&
        other.id == id &&
        other.sectionName == sectionName &&
        listEquals(other.subsections, subsections);
  }

  @override
  int get hashCode => id.hashCode ^ sectionName.hashCode ^ subsections.hashCode;

  @override
  String toString() =>
      'DocumentSection(sectionId: $id, sectionName: $sectionName, subsections: $subsections)';
}
