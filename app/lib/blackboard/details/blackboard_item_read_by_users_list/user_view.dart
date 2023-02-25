// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:meta/meta.dart';
import 'package:user/user.dart';

class UserView {
  final String uid;
  final String name;
  final String abbrevation;
  final String typeOfUser;
  final bool hasRead;

  UserView({
    @required this.uid,
    @required this.name,
    @required this.hasRead,
    @required this.typeOfUser,
  }) : abbrevation = generateAbbreviation(name);
}
