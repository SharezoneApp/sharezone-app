// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/src/models/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

/// A stream that sends the current [AuthUser] whenever the authentication state
/// changes. changes.
///
/// We wrap the Firebase [authStateChanges] stream in a [BehaviorSubject] to be
/// able to to "simulate" a logout just before we actually log out. This is is
/// necessary to prevent a weird bug where the firestore streams are still
/// active which results in permission denied errors.
///
/// See the following references for more information:
/// * https://github.com/SharezoneApp/sharezone-app/pull/1415
/// * https://github.com/SharezoneApp/sharezone-app/issues/174
final authUserSubject = BehaviorSubject<AuthUser?>.seeded(null);
Stream<AuthUser?> get authUserStream => authUserSubject.stream;

Stream<AuthUser?> listenToAuthStateChanged() {
  return FirebaseAuth.instance.authStateChanges().map(
    (firebaseUser) => AuthUser.fromFirebaseUser(firebaseUser),
  );
}
