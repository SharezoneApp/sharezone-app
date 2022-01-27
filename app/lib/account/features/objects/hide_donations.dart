// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/account/features/objects/feature.dart';

/// Wie kann der Donate-Button aus dem Drawer ausgeblendet werden? Im
/// User-Dokument muss das Attribut 'features' als Map hinzugefügt werden.
/// Danach muss zu dieser Map der Schlüssel "hideDonations" mit dem Wert "true"
/// hinzugefügt werden.
class HideDonations extends Feature {
  HideDonations() : super("hideDonations");
}
