// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/abgabe_client_lib.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthTokenRetreiverImpl extends FirebaseAuthTokenRetreiver {
  FirebaseAuthTokenRetreiverImpl(this._user);
  final User _user;

  @override
  Future<String> getToken() async {
    return await _user.getIdToken();
  }
}
