// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

enum TypeOfUser { student, teacher, parent, unknown }

extension TypeOfUserExtension on TypeOfUser {
  bool get isTeacher => this == TypeOfUser.teacher;
  bool get isParent => this == TypeOfUser.parent;
  bool get isStudent => this == TypeOfUser.student;

  String toLocalizedString(BuildContext context) {
    return switch (this) {
      TypeOfUser.student => context.l10n.typeOfUserStudent,
      TypeOfUser.teacher => context.l10n.typeOfUserTeacher,
      TypeOfUser.parent => context.l10n.typeOfUserParent,
      TypeOfUser.unknown => context.l10n.typeOfUserUnknown,
    };
  }
}
