// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

enum WeekType { always, a, b }

String weekTypeEnumToLocalizedString(BuildContext context, WeekType weekType) {
  final l10n = context.l10n;
  switch (weekType) {
    case WeekType.always:
      return l10n.dateWeekTypeAlways;
    case WeekType.a:
      return l10n.dateWeekTypeA;
    case WeekType.b:
      return l10n.dateWeekTypeB;
  }
}
