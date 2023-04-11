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
  /// when force-closing a section which is currently read.
  /// In this case we wait to expand it again only after we stopped reading the
  /// current section since else it would expand automatically right away when
  /// scrolling between the subsections of the just manually closed section.
  /// This would be unexpected to a user.
  forced,

  /// The [TocSection] is expanded automatically because it is currently read or
  /// is collapsed automatically because it is not currently read.
  automatic,
}

/// The [ExpansionState] of a [TocSection]. Encapsulates if a [TocSection] is
/// expanded and why (automatically or manually/forced).
///
/// See also [ExpansionMode] and [_computeNewExpansionState] to learn more about
/// the expansion/collapsing behavior.
class ExpansionState implements ExpansionBehavior {
  final bool isExpanded;
  final ExpansionMode expansionMode;
  final ExpansionBehavior expansionBehavior;

  ExpansionState({
    @required this.isExpanded,
    @required this.expansionMode,
    @required this.expansionBehavior,
  });

  @override
  ExpansionState computeExpansionState({TocSection before, TocSection after}) {
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

abstract class ExpansionBehavior {
  const ExpansionBehavior();

  static const ExpansionBehavior leaveManuallyOpenedSectionsOpen =
      _LeaveManuallyOpenedSectionsOpenExpansionBehavior();
  static const ExpansionBehavior alwaysAutomaticallyCloseSectionsAgain =
      _AlwaysCloseAgainExpansionBehavior();

  static void assertValid({
    @required TocSection before,
    @required TocSection after,
  }) {
    assert(before.isExpandable);
    assert(after.isExpandable);
    assert(
        before.expansionStateOrNull.isExpanded ==
            after.expansionStateOrNull.isExpanded,
        "expansionState hasn't changed already (since this method is responsible for changing it)");
    assert(
        before.expansionStateOrNull.expansionMode ==
            after.expansionStateOrNull.expansionMode,
        "expansionState hasn't changed already (since this method is responsible for changing it)");

    // We use enums inside if clauses because of readability.
    // We check here that there weren't any other Enum Values introduced by
    // accident.
    assert(before.expansionStateOrNull.expansionMode == ExpansionMode.forced ||
        before.expansionStateOrNull.expansionMode == ExpansionMode.automatic);
    assert(after.expansionStateOrNull.expansionMode == ExpansionMode.forced ||
        after.expansionStateOrNull.expansionMode == ExpansionMode.automatic);
  }

  /// Compute the new [ExpansionState] for [after].
  ///
  /// Called when [before] was updated to [after] with a new
  /// [TocSection.isThisCurrentlyRead] state.
  ExpansionState computeExpansionState({
    @required TocSection before,
    @required TocSection after,
  });
}

/// Used in mobile layouts where expanded sections will take more place and just
/// don't feel right when they stay open indefinitely (until closing manually
/// again) if you manually expanded them.
///
/// In a perfect world we would maybe also call a `tableOfContentsWasClosed()`
/// method on the toc section that will cause manually opened sections to close
/// because right now the section will stay open if you open, close and then
/// open again the bottom sheet but will close if you open, close, scroll to a
/// new section (which will invoke this method) and open the bottom sheet again
/// which is kinda inconsistent.
///
/// But this is also more logic and coupling to the UI for behavior probably no
/// one will notice so I will just leave it like this right now.
class _AlwaysCloseAgainExpansionBehavior extends ExpansionBehavior {
  const _AlwaysCloseAgainExpansionBehavior();

  @override
  ExpansionState computeExpansionState({
    @required TocSection before,
    @required TocSection after,
  }) {
    ExpansionBehavior.assertValid(before: before, after: after);
    // Automatic default behavior:
    // - Expand if the section or a subsection is currently read.
    // - Collapse if the section or a subsection is not currently read.
    return before.expansionStateOrNull.copyWith(
      isExpanded: after.isThisOrASubsectionCurrentlyRead,
    );
  }
}

class _LeaveManuallyOpenedSectionsOpenExpansionBehavior
    extends ExpansionBehavior {
  const _LeaveManuallyOpenedSectionsOpenExpansionBehavior();

  @override
  ExpansionState computeExpansionState({
    @required TocSection before,
    @required TocSection after,
  }) {
    ExpansionBehavior.assertValid(before: before, after: after);

    final oldExpansionState = before.expansionStateOrNull;
    final expansionMode = oldExpansionState.expansionMode;
    final wasExpanded = oldExpansionState.isExpanded;
    final wasCollapsed = !wasExpanded;

    // Automatic default behavior:
    // - Expand if the section or a subsection is currently read.
    // - Collapse if the section or a subsection is not currently read.
    if (expansionMode == ExpansionMode.automatic) {
      return oldExpansionState.copyWith(
        isExpanded: after.isThisOrASubsectionCurrentlyRead,
      );
    }

    // [ExpansionMode.forced] means that a user manually expanded / collapsed a
    // section by e.g. tapping on an expansion icon.
    if (expansionMode == ExpansionMode.forced) {
      // We are in force-opened section.
      // We leave the section expanded regardless if it is currently read or not.
      if (wasExpanded) {
        return oldExpansionState.copyWith(
          isExpanded: true,
        );
      }

      // We are in a force-collapsed section.
      // So either the user manually collapsed a automatically opened section
      // (i.e a section that is currently read) or he manually opened and then
      // closed a section that was not currently read.
      if (wasCollapsed) {
        // We are in a force-collapsed section / we force-collapsed a section
        // that we were already reading.
        //
        // It stays collapsed since else collapsing a currently read section and
        // scrolling around in it (changing currently read of the subsections)
        // would expand it right away again which is unexpected for the user.
        if (before.isThisOrASubsectionCurrentlyRead &&
            after.isThisOrASubsectionCurrentlyRead) {
          return oldExpansionState.copyWith(
            isExpanded: false,
          );
        }

        /// In any other case we just switch back to the automatic behavior (there
        /// is no "stay always closed" behavior).
        return oldExpansionState.copyWith(
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
}
