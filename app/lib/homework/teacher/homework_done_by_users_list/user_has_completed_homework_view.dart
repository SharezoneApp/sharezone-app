// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:user/user.dart';

class UserHasCompletedHomeworkView {
  final String uid;
  final String name;
  final String abbreviation;
  final bool hasDone;

  UserHasCompletedHomeworkView({
    required this.uid,
    required this.name,
    required this.hasDone,
  }) : abbreviation = generateAbbreviation(name);
}
