// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart';
import 'package:user/user.dart';

class UserView {
  final String id;
  final String name;
  final String abbreviation;
  final String? email;
  final String userType;
  final String? state;
  final bool isAnonymous;
  final Provider? provider;

  /// [User] wird benötigt, um auf andere Seite zu pushen, die den User noch
  /// voraussetzen.
  final AppUser user;

  UserView({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.email,
    required this.userType,
    required this.isAnonymous,
    required this.state,
    required this.provider,
    required this.user,
  });

  UserView.fromUserAndFirebaseUser(this.user, AuthUser? authUser)
      : id = user.id,
        name = user.name,
        abbreviation = user.abbreviation,
        email = authUser?.email,
        userType = user.typeOfUser.toReadableString(),
        isAnonymous = authUser?.isAnonymous ?? false,
        state = stateEnumToString[user.state],
        provider = authUser?.provider;

  UserView.empty()
      : id = "",
        name = "",
        abbreviation = "",
        email = "",
        userType = "",
        state = "",
        isAnonymous = false,
        provider = null,
        user = AppUser.create(id: "");
}
