// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart';
import 'package:meta/meta.dart';
import 'package:user/user.dart';

class UserView {
  /// Der [AppUser] wird benötigt, da einige Unterseiten
  /// den gesamten User benötigten.
  final AppUser user;
  final String id;
  final String name;
  final String email;
  final String state;
  final String typeOfUser;
  final bool isAnonymous;
  final Provider provider;

  UserView({
    @required this.id,
    @required this.user,
    @required this.name,
    @required this.email,
    @required this.typeOfUser,
    @required this.state,
    @required this.isAnonymous,
    @required this.provider,
  });

  UserView.fromUserAndFirebaseUser(this.user, AuthUser authUser)
      : id = user.id,
        name = user.name,
        email = authUser.email,
        state = stateEnumToString[user.state],
        typeOfUser = user.typeOfUser.toReadableString(),
        isAnonymous = authUser.isAnonymous,
        provider = authUser.provider;

  factory UserView.empty() {
    return UserView(
      id: "",
      user: AppUser.create(id: ""),
      email: "",
      name: "",
      typeOfUser: "",
      isAnonymous: true,
      provider: null,
      state: "",
    );
  }
}
