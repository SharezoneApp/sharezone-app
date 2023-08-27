// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:group_domain_models/group_domain_models.dart';

class SplittedMemberList {
  final List<MemberData> admins, creator, reader;

  SplittedMemberList({
    this.admins = const [],
    this.creator = const [],
    this.reader = const [],
  });
}
