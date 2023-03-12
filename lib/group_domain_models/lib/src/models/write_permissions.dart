// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

enum WritePermission { everyone, onlyAdmins }

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
