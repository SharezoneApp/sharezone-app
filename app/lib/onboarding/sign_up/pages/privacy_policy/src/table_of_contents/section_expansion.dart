// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of './table_of_contents.dart';

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
  // We use enum because it's more readable but don't use a switch statement
  // because it makes its more unreadable than an if-else.
  assert(after.expansionState.expansionMode == ExpansionMode.forced ||
      after.expansionState.expansionMode == ExpansionMode.automatic);

  // Default behavior
  if (before.expansionState.expansionMode == ExpansionMode.automatic) {
    return after.expansionState.copyWith(
      isExpanded: after.isThisOrASubsectionCurrentlyRead,
    );
  }

  if (before.expansionState.expansionMode == ExpansionMode.forced) {
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
    if (after.isCollapsed &&
        // ... and we just started reading this
        !before.isThisOrASubsectionCurrentlyRead &&
        after.isThisOrASubsectionCurrentlyRead) {
      // ... then we expand it and change to the default auto-expand behavior
      return ExpansionState(
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
    return after.expansionState.copyWith(
      isExpanded: before.isExpanded,
    );
  }

  throw UnimplementedError();
}
