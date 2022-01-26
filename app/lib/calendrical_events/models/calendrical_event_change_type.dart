// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2


/// Der EventChangeType gibt an, wie sich der Termin zu den Stundenverhält.
/// [NONE] => Stunden bleiben so.
/// [CHANGE] => Der Termin stellt eine Änderung der Stunden dar
/// [ELIMINATION] => Durch den Termin entfallen die Stunden.
enum CalendricalEventChangeType {
  none,
  change,
  elimination,
}
