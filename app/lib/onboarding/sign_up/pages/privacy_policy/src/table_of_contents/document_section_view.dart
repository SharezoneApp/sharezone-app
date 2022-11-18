// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';

import '../privacy_policy_src.dart';

class TocDocumentSectionView {
  final DocumentSectionId id;
  final String sectionHeadingText;
  final IList<TocDocumentSectionView> subsections;
  final bool shouldHighlight;
  final bool isExpanded;
  bool get isExpandable => subsections.isNotEmpty;

  TocDocumentSectionView({
    @required this.id,
    @required this.sectionHeadingText,
    @required this.subsections,
    @required this.shouldHighlight,
    @required this.isExpanded,
  }) : assert(() {
          // If there are no subsections there cant be a way
          // for the section to be expanded.
          if (subsections.isEmpty) {
            return isExpanded == false;
          }
          return true;
        }());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is TocDocumentSectionView &&
        other.id == id &&
        other.sectionHeadingText == sectionHeadingText &&
        listEquals(other.subsections, subsections) &&
        other.shouldHighlight == shouldHighlight &&
        other.isExpanded == isExpanded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sectionHeadingText.hashCode ^
        subsections.hashCode ^
        shouldHighlight.hashCode ^
        isExpanded.hashCode;
  }

  @override
  String toString() {
    return 'TocDocumentSectionView(id: $id, sectionHeadingText: $sectionHeadingText, subsections: $subsections, shouldHighlight: $shouldHighlight, isExpanded: $isExpanded)';
  }
}
