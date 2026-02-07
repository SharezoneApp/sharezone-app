// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

enum WritePermission {
  everyone,
  onlyAdmins;

  String toLocalizedString(BuildContext context) {
    return switch (this) {
      WritePermission.everyone => context.l10n.writePermissionEveryone,
      WritePermission.onlyAdmins => context.l10n.writePermissionOnlyAdmins,
    };
  }
}
