// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_common/helper_functions.dart';

enum MemberRole {
  owner,
  admin,
  creator,
  standard,
  none,
}

MemberRole memberRoleEnumFromString(String data) =>
    enumFromString(MemberRole.values, data);
String memberRoleEnumToString(MemberRole memberRole) =>
    enumToString(memberRole);
const Map<MemberRole, String> memberRoleAsString = {
  MemberRole.admin: "Admin",
  MemberRole.creator: "Aktives Mitglied (Schreib- und Leserechte)",
  MemberRole.standard: "Passives Mitglied (Nur Leserechte)",
  MemberRole.owner: "Besitzer",
  MemberRole.none: "Nichts",
};
