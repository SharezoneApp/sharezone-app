// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

enum WeekType {
  always,
  a,
  b;

  String toLocalizedString(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      WeekType.always => l10n.dateWeekTypeAlways,
      WeekType.a => l10n.dateWeekTypeA,
      WeekType.b => l10n.dateWeekTypeB,
    };
  }
}
