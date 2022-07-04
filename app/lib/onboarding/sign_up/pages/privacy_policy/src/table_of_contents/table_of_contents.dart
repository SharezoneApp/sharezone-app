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

class DocumentSectionId extends Id {
  DocumentSectionId(String id) : super(id, 'DocumentSectionId');
}

class TableOfContents {
  final IList<TocSection> sections;

  TableOfContents(this.sections);

  TableOfContents manuallyToggleShowSubsectionsOf(DocumentSectionId sectionId) {
    return copyWith(
      sections: sections
          .replaceAllWhereMap((section) => section.id == sectionId,
              (section) => section.toggleExpansionManually())
          .toIList(),
    );
  }

  TableOfContents copyWith({
    IList<TocSection> sections,
  }) {
    return TableOfContents(
      sections ?? this.sections,
    );
  }

  TableOfContents changeCurrentlyReadSectionTo(
      DocumentSectionId currentlyReadSection) {
    return copyWith(
      sections: sections
          .map((section) =>
              section.changeCurrentlyReadAccordingly(currentlyReadSection))
          .toIList(),
    );
  }
}

extension ReplaceAllWhere<T> on IList<T> {
  Iterable<T> replaceAllWhereMap(
      Predicate<T> test, T Function(T element) toElement,
      {ConfigList config}) {
    return map((element) => test(element) ? toElement(element) : element,
        config: config);
  }
}

enum ExpansionMode { forced, automatic }

class TocSection {
  final DocumentSectionId id;
  final String title;
  final IList<TocSection> subsections;

  final ExpansionMode expansionMode;
  final bool isExpanded;
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
    @required this.isExpanded,
    @required this.isThisCurrentlyRead,
    @required this.expansionMode,
  }) : assert(subsections
                .where((element) => element.isThisOrASubsectionCurrentlyRead)
                .length <=
            1) {
    if (subsections.isEmpty && isExpanded) {
      throw ArgumentError(
          '$TocSection cant be expanded if it has no subsections');
    }
  }

  TocSection toggleExpansionManually() {
    if (subsections.isEmpty) {
      throw ArgumentError();
    }
    return copyWith(
      isExpanded: !isExpanded,
      expansionMode: ExpansionMode.forced,
    );
  }

  // TODO: Rename method (so its clear that it changes also its expansion
  // instead of only updating the currently read state)
  TocSection changeCurrentlyReadAccordingly(
      DocumentSectionId newCurrentlyReadSection) {
    final newSubsections = subsections
        .map((subsection) =>
            subsection.changeCurrentlyReadAccordingly(newCurrentlyReadSection))
        .toIList();

    TocSection updated = copyWith(
      isThisCurrentlyRead: id == newCurrentlyReadSection,
      subsections: newSubsections,
    );

    if (isExpandable) {
      updated = _updateWithComputedExpansion(
        old: this,
        partiallyUpdated: updated,
      );
    }

    return updated;
  }

  TocSection copyWith({
    DocumentSectionId id,
    String title,
    IList<TocSection> subsections,
    ExpansionMode expansionMode,
    bool isExpanded,
    bool isThisCurrentlyRead,
  }) {
    return TocSection(
      id: id ?? this.id,
      title: title ?? this.title,
      subsections: subsections ?? this.subsections,
      expansionMode: expansionMode ?? this.expansionMode,
      isExpanded: isExpanded ?? this.isExpanded,
      isThisCurrentlyRead: isThisCurrentlyRead ?? this.isThisCurrentlyRead,
    );
  }

  @override
  String toString() {
    return 'TocSection(id: $id, title: $title, subsections: $subsections, expansionMode: $expansionMode, isExpanded: $isExpanded, isThisCurrentlyRead: $isThisCurrentlyRead, isThisOrASubsectionCurrentlyRead: $isThisOrASubsectionCurrentlyRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TocSection &&
        other.id == id &&
        other.title == title &&
        other.subsections == subsections &&
        other.expansionMode == expansionMode &&
        other.isExpanded == isExpanded &&
        other.isThisCurrentlyRead == isThisCurrentlyRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        subsections.hashCode ^
        expansionMode.hashCode ^
        isExpanded.hashCode ^
        isThisCurrentlyRead.hashCode;
  }
}

TocSection _updateWithComputedExpansion({
  @required TocSection old,
  @required TocSection partiallyUpdated,
}) {
  assert(old.isExpandable);
  assert(partiallyUpdated.isExpandable);
  // We use enum because it's more readable but don't use a switch statement
  // because it makes its more unreadable than an if-else.
  assert(partiallyUpdated.expansionMode == ExpansionMode.forced ||
      partiallyUpdated.expansionMode == ExpansionMode.automatic);

  // Default behavior
  if (old.expansionMode == ExpansionMode.automatic) {
    return partiallyUpdated.copyWith(
      isExpanded: partiallyUpdated.isThisOrASubsectionCurrentlyRead,
    );
  }

  if (old.expansionMode == ExpansionMode.forced) {
    // When we go from some other section into a forced closed one we update
    // the current section to it's "automatic" expansion mode (i.e. it
    // expands again).
    //
    // We want that manually closed sections only stay closed when currently
    // read and scrolling aroung in it.
    // In every other case manually closing a section makes it expand
    // automatically again when it is read (this is the case here).
    //
    // *Implementation note*
    // This was implemented before that if we force-closed a currently read
    // section and scrolled out of it that we would update the [ExpansionMode]
    // to [ExpansionMode.automatic] again.
    // This had the problem that if we come from a "no section read" state (e.g.
    // this is the first section) that a force-closed section wouldn't open
    // since we have never scrolled out of it (currently reading wasn't updated
    // before we entered this section).

    // If this is force-closed...
    if (partiallyUpdated.isCollapsed &&
        // ... and we just started reading this
        !old.isThisOrASubsectionCurrentlyRead &&
        partiallyUpdated.isThisOrASubsectionCurrentlyRead) {
      // ... then we expand it and change to the default auto-expand behavior
      return partiallyUpdated.copyWith(
        isExpanded: true,
        expansionMode: ExpansionMode.automatic,
      );
    }

    // Behavior for if we
    //
    // 1. were and still are in a force-closed section.
    //    It stays closed since else closing a currently read section and
    //    scrolling around in it would expand it again right away.
    //
    // 2. are in a forced open section which is ment to always stay open until
    //    a user closes it again manually.
    //
    // Altough this will also be the run if we scroll out of a forced-close
    // section since we update to the default auto-expand mode only if when we
    // enter the section again (see above).

    // We could also just return [partiallyUpdated] but this is more explicit.
    return partiallyUpdated.copyWith(
      isExpanded: old.isExpanded,
    );
  }

  throw UnimplementedError();
}
