// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_common/helper_functions.dart';

enum WritePermission { everyone, onlyAdmins }

WritePermission writePermissionEnumFromString(String data) =>
    enumFromString(WritePermission.values, data);
String writePermissionEnumToString(WritePermission writePermissions) =>
    enumToString(writePermissions);

String writePermissionAsUiString(WritePermission writePermission) {
  switch (writePermission) {
    case WritePermission.everyone:
      return 'Alle';
    case WritePermission.onlyAdmins:
      return 'Nur Admins';
    default:
      return 'Einstellung konnte nicht gefunden werden';
  }
}
