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

abstract class ExpansionBehavior {
  const ExpansionBehavior();

  static const ExpansionBehavior leaveManuallyOpenedSectionsOpen =
      _LeaveManuallyOpenedSectionsOpenExpansionBehavior();
  static const ExpansionBehavior alwaysAutomaticallyCloseSectionsAgain =
      _AlwaysCloseAgainExpansionBehavior();

  /// Compute the new [TocSectionExpansionState] for [after].
  ///
  /// Called when [before] was updated to [after] with a new
  /// [TocSection.isThisCurrentlyRead] state.
  TocSectionExpansionState computeExpansionState({
    required TocSection? before,
    required TocSection? after,
  });

  /// Common assertions for all [ExpansionBehavior]s.
  /// Needs to be called by all subclasses manually.
  static void assertValid({
    required TocSection before,
    required TocSection after,
  }) {
    assert(before.isExpandable);
    assert(after.isExpandable);
    assert(
        before.expansionStateOrNull!.isExpanded ==
            after.expansionStateOrNull!.isExpanded,
        "expansionState hasn't changed already (since this method is responsible for changing it)");
    assert(
        before.expansionStateOrNull!.expansionMode ==
            after.expansionStateOrNull!.expansionMode,
        "expansionState hasn't changed already (since this method is responsible for changing it)");

    // We use if instead of switch to check which [ExpansionMode] we are dealing
    // with in the ExpansionBehavior subclasses for better readability.
    // This means that we're not getting a lint if a new [ExpansionMode] is
    // introduced and not accounted for by the subclasses.
    //
    // We check here that no new Enum Values are introduced by accident.
    // If a new Enum value is introduced it should be checked that all usages
    // of the enum are accounted for in the subclasses.
    assert(before.expansionStateOrNull!.expansionMode == ExpansionMode.forced ||
        before.expansionStateOrNull!.expansionMode == ExpansionMode.automatic);
    assert(after.expansionStateOrNull!.expansionMode == ExpansionMode.forced ||
        after.expansionStateOrNull!.expansionMode == ExpansionMode.automatic);
  }
}

/// Expand sections automatically if they are currently read and collapse them
/// if not.
///
/// Used in mobile layouts which use the table of contents bottom sheet.
class _AlwaysCloseAgainExpansionBehavior extends ExpansionBehavior {
  const _AlwaysCloseAgainExpansionBehavior();

  @override
  TocSectionExpansionState computeExpansionState({
    required TocSection? before,
    required TocSection? after,
  }) {
    ExpansionBehavior.assertValid(before: before!, after: after!);
    // Automatic default behavior:
    // - Expand if the section or a subsection is currently read.
    // - Collapse if the section or a subsection is not currently read.
    return before.expansionStateOrNull!.copyWith(
      isExpanded: after.isThisOrASubsectionCurrentlyRead,
    );
  }
}

/// Like [_AlwaysCloseAgainExpansionBehavior] but leaves manually opened
/// sections open.
///
/// Used in desktop layouts which use has the table of contents as a sidebar.
///
/// The reason for this behavior is that it might be confusing if a user expands
/// a section manually and scrolls from this section to another section inside
/// the text, which would cause the manually opened section to collapse
/// automatically if we would use [_AlwaysCloseAgainExpansionBehavior].
class _LeaveManuallyOpenedSectionsOpenExpansionBehavior
    extends ExpansionBehavior {
  const _LeaveManuallyOpenedSectionsOpenExpansionBehavior();

  @override
  TocSectionExpansionState computeExpansionState({
    required TocSection? before,
    required TocSection? after,
  }) {
    ExpansionBehavior.assertValid(before: before!, after: after!);

    final oldExpansionState = before.expansionStateOrNull!;
    final expansionMode = oldExpansionState.expansionMode;
    final wasExpanded = oldExpansionState.isExpanded;
    final wasCollapsed = !wasExpanded;

    // Automatic default behavior:
    // - Expand if the section or a subsection is currently read.
    // - Collapse if the section or a subsection is not currently read.
    // (like [_AlwaysCloseAgainExpansionBehavior])
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
