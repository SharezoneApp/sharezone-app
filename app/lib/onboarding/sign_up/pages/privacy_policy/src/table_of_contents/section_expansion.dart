// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of './table_of_contents.dart';

enum ExpansionMode {
  /// The user manually expanded a section by e.g. clicking on the expansion
  /// arrow.
  ///
  /// This will cause the [TocSection] to stay open until the user manually
  /// collapses it again.
  ///
  /// A force-closed section will behave like [ExpansionMode.automatic] expect
  /// when force-closing a section which we currently read. In this case it
  /// will only start to expand automatically again when we first stopped
  /// reading this section.
  forced,

  /// The [TocSection] is expanded automatically because it is currently read or
  /// is collapsed automatically because it is not currently read.
  automatic,
}

/// [ExpansionState] of a [TocSection].
class ExpansionState {
  final bool isExpanded;
  final ExpansionMode expansionMode;

  ExpansionState({
    @required this.isExpanded,
    @required this.expansionMode,
  });

  ExpansionState copyWith({
    bool isExpanded,
    ExpansionMode expansionMode,
  }) {
    return ExpansionState(
      isExpanded: isExpanded ?? this.isExpanded,
      expansionMode: expansionMode ?? this.expansionMode,
    );
  }

  @override
  String toString() =>
      'ExpansionState(isExpanded: $isExpanded, expansionMode: $expansionMode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpansionState &&
        other.isExpanded == isExpanded &&
        other.expansionMode == expansionMode;
  }

  @override
  int get hashCode => isExpanded.hashCode ^ expansionMode.hashCode;
}

/// Compute the new [ExpansionState] for [after].
///
/// Called when [before] was updated to [after] with a new
/// [TocSection.isThisCurrentlyRead] state.
ExpansionState _computeNewExpansionState({
  @required TocSection before,
  @required TocSection after,
}) {
  assert(before.isExpandable);
  assert(after.isExpandable);
  // We use enums inside if clauses because of readability.
  assert(after.expansionState.expansionMode == ExpansionMode.forced ||
      after.expansionState.expansionMode == ExpansionMode.automatic);

  // Automatic default behavior:
  // Expand if the section or a subsection is currently read.
  if (before.expansionState.expansionMode == ExpansionMode.automatic) {
    return after.expansionState.copyWith(
      isExpanded: after.isThisOrASubsectionCurrentlyRead,
    );
  }

  if (before.expansionState.expansionMode == ExpansionMode.forced) {
    // If we are in force-opened section we leave the section expanded.
    if (before.expansionState.isExpanded) {
      return after.expansionState.copyWith(
        isExpanded: true,
      );
    }

    // We are in a force-collapsed section.
    if (before.isCollapsed) {
      // We force-collapsed a section we were already currently reading.
      //
      // It stays collapsed since else collapsing a currently read section and
      // scrolling around in it (changing currently read of the subsections)
      // would expand it again right away again which is unexpected for the
      // user.
      if (before.isThisOrASubsectionCurrentlyRead &&
          after.isThisOrASubsectionCurrentlyRead) {
        return after.expansionState.copyWith(
          isExpanded: before.isExpanded,
        );
      }

      /// In any other case we just switch back to the automatic behavior (there
      /// is no "stay always closed" behavior).
      return after.expansionState.copyWith(
        expansionMode: ExpansionMode.automatic,
        isExpanded: after.isThisOrASubsectionCurrentlyRead,
      );
    }
  }

  // Make the linter happy, we should never get here.
  // (We don't use if-else and use enums instead of bools in some cases for
  // better readability but this will cause the linter to complain that we won't
  // always return a value if we don't throw an error here.)
  throw UnimplementedError();
}
