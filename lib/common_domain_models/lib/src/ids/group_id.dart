// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'src/id.dart';

/// Id für eine Gruppe (Kurs, Klasse, etc)
/// Der Gedanke dahinter ist, dass die für Operationen, die möglichweise
/// für mehrere Arten von Gruppen gelten könnte als Parameter genutzt werden kann.
class GroupId extends Id {
  GroupId(String id, [String typeOfGroup])
      : super(id, typeOfGroup ?? 'GroupId');
}
