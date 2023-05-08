// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';

part './section_expansion.dart';

class DocumentSectionId extends Id {
  DocumentSectionId(String id) : super(id, 'DocumentSectionId');
}

class TableOfContents {
  final IList<TocSection> sections;
  ExpansionBehavior expansionBehavior;

  TableOfContents(this.sections, this.expansionBehavior)
      : assert(() {
          final sectionsHaveCorrectExpansionBehavior = sections.every(
              (element) =>
                  element.expansionStateOrNull == null ||
                  element.expansionStateOrNull.expansionBehavior ==
                      expansionBehavior);

          return sectionsHaveCorrectExpansionBehavior;
        }());

  TableOfContents changeCurrentlyReadSectionTo(
      DocumentSectionId currentlyReadSection) {
    return _copyWith(
        sections: sections
            .map((section) =>
                section.notifyOfNewCurrentlyRead(currentlyReadSection))
            .toIList());
  }

  TableOfContents forceToggleExpansionOf(DocumentSectionId sectionId) {
    return _copyWith(
      sections: sections
          .replaceWhere(
            where: (section) => section.id == sectionId,
            replace: (section) => section.forceToggleExpansion(),
          )
          .toIList(),
    );
  }

  TableOfContents _copyWith({
    IList<TocSection> sections,
    ExpansionBehavior expansionBehavior,
  }) {
    return TableOfContents(
      sections ?? this.sections,
      expansionBehavior ?? this.expansionBehavior,
    );
  }

  TableOfContents changeExpansionBehaviorTo(
      ExpansionBehavior newExpansionBehavior) {
    // This check is important for performance reasons - when resizing the
    // window / redrawing often this method gets called very often without
    // a different [expansionBehavior] we should change to.
    //
    // Every section should have the same behavior so we only check the first
    // section.
    if (expansionBehavior == newExpansionBehavior) {
      return this;
    }

    return _copyWith(
      sections: sections
          .map((section) =>
              section.changeExpansionBehaviorTo(newExpansionBehavior))
          .toIList(),
      expansionBehavior: newExpansionBehavior,
    );
  }
}

class TocSection {
  final DocumentSectionId id;
  final String title;
  final IList<TocSection> subsections;

  final ExpansionState expansionStateOrNull;
  bool get isExpanded => expansionStateOrNull?.isExpanded ?? false;
  bool get isCollapsed => !isExpanded;
  bool get isExpandable => subsections.isNotEmpty;

  final bool isThisCurrentlyRead;
  bool get isThisOrASubsectionCurrentlyRead =>
      isThisCurrentlyRead ||
      subsections
          .where((subsection) => subsection.isThisOrASubsectionCurrentlyRead)
          .isNotEmpty;

  TocSection({
    @required this.id,
    @required this.title,
    @required this.subsections,
    @required this.isThisCurrentlyRead,
    this.expansionStateOrNull,
  }) : assert(subsections
                .where((element) => element.isThisOrASubsectionCurrentlyRead)
                .length <=
            1) {
    if (subsections.isEmpty && isExpanded) {
      throw ArgumentError(
          '$TocSection cant be expanded if it has no subsections');
    }
  }

  TocSection forceToggleExpansion() {
    if (!isExpandable) {
      throw ArgumentError();
    }
    return _copyWith(
      expansionStateOrNull: expansionStateOrNull.copyWith(
        isExpanded: !isExpanded,
        expansionMode: ExpansionMode.forced,
      ),
    );
  }

  TocSection changeExpansionBehaviorTo(ExpansionBehavior expansionBehavior) {
    if (!isExpandable) {
      return this;
    }

    return _copyWith(
      expansionStateOrNull:
          expansionStateOrNull.copyWith(expansionBehavior: expansionBehavior),
    );
  }

  /// Change [isThisCurrentlyRead] and [expansionStateOrNull] of this and
  /// [subsections] and according to [newCurrentlyReadSection].
  ///
  /// For example if this [TocSection.id] == [newCurrentlyReadSection] and the
  /// [ExpansionMode] == [ExpansionMode.automatic] then calling
  /// [notifyOfNewCurrentlyRead] would return an updated version of `this` with
  /// [isThisCurrentlyRead] == `true` and [isExpanded] == `true`.
  TocSection notifyOfNewCurrentlyRead(
      DocumentSectionId newCurrentlyReadSection) {
    final newSubsections = subsections
        .map((subsection) =>
            subsection.notifyOfNewCurrentlyRead(newCurrentlyReadSection))
        .toIList();

    TocSection updated = _copyWith(
      isThisCurrentlyRead: id == newCurrentlyReadSection,
      subsections: newSubsections,
    );

    if (isExpandable) {
      updated = updated._copyWith(
        expansionStateOrNull: expansionStateOrNull.computeNewExpansionState(
            before: this, after: updated),
      );
    }

    return updated;
  }

  TocSection _copyWith({
    DocumentSectionId id,
    String title,
    IList<TocSection> subsections,
    ExpansionState expansionStateOrNull,
    bool isThisCurrentlyRead,
  }) {
    return TocSection(
      id: id ?? this.id,
      title: title ?? this.title,
      subsections: subsections ?? this.subsections,
      expansionStateOrNull: expansionStateOrNull ?? this.expansionStateOrNull,
      isThisCurrentlyRead: isThisCurrentlyRead ?? this.isThisCurrentlyRead,
    );
  }

  @override
  String toString() {
    return 'TocSection(id: $id, title: $title, subsections: $subsections, expansionStateOrNull: $expansionStateOrNull, isThisCurrentlyRead: $isThisCurrentlyRead, isThisOrASubsectionCurrentlyRead: $isThisOrASubsectionCurrentlyRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TocSection &&
        other.id == id &&
        other.title == title &&
        other.subsections == subsections &&
        other.expansionStateOrNull == expansionStateOrNull &&
        other.isThisCurrentlyRead == isThisCurrentlyRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        subsections.hashCode ^
        expansionStateOrNull.hashCode ^
        isThisCurrentlyRead.hashCode;
  }
}

/// The [ExpansionState] of a [TocSection]. Encapsulates if a [TocSection] is
/// expanded and why (automatically or manually/forced).
///
/// See also [ExpansionMode] and [_computeNewExpansionState] to learn more about
/// the expansion/collapsing behavior.
class ExpansionState {
  final bool isExpanded;
  final ExpansionMode expansionMode;
  final ExpansionBehavior expansionBehavior;

  ExpansionState({
    @required this.isExpanded,
    @required this.expansionMode,
    @required this.expansionBehavior,
  });

  ExpansionState computeNewExpansionState(
      {TocSection before, TocSection after}) {
    return expansionBehavior.computeExpansionState(
        before: before, after: after);
  }

  ExpansionState copyWith({
    bool isExpanded,
    ExpansionMode expansionMode,
    ExpansionBehavior expansionBehavior,
  }) {
    return ExpansionState(
      isExpanded: isExpanded ?? this.isExpanded,
      expansionMode: expansionMode ?? this.expansionMode,
      expansionBehavior: expansionBehavior ?? this.expansionBehavior,
    );
  }

  @override
  String toString() =>
      'ExpansionState(isExpanded: $isExpanded, expansionMode: $expansionMode, expansionBehavior: $expansionBehavior)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpansionState &&
        other.isExpanded == isExpanded &&
        other.expansionMode == expansionMode &&
        other.expansionBehavior == expansionBehavior;
  }

  @override
  int get hashCode =>
      isExpanded.hashCode ^ expansionMode.hashCode ^ expansionBehavior.hashCode;
}

extension ReplaceWhere<T> on IList<T> {
  Iterable<T> replaceWhere({
    @required Predicate<T> where,
    @required T Function(T element) replace,
    ConfigList config,
  }) {
    return map(
      (element) => where(element) ? replace(element) : element,
      config: config,
    );
  }
}
