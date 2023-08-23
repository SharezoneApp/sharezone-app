// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/src/models/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

Stream<AuthUser?> listenToAuthStateChanged() {
  return FirebaseAuth.instance
      .authStateChanges()
      .map((firebaseUser) => AuthUser.fromFirebaseUser(firebaseUser));
}
