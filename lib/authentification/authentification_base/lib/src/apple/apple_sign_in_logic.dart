// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AppleSignInLogic {
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Signs in the user with Apple.
  ///
  /// Returns the user if the sign in was successful.
  ///
  /// Returns null if the user cancels the sign in process. Throws an exception
  /// if the sign in fails.
  Future<UserCredential?> signIn() async {
    final appleProvider = AppleAuthProvider();

    if (kIsWeb) {
      return auth.signInWithPopup(appleProvider);
    } else {
      return auth.signInWithProvider(appleProvider);
    }
  }

  Future<void> linkWithApple() async {
    final appleProvider = AppleAuthProvider();

    if (kIsWeb) {
      await auth.currentUser!.linkWithPopup(appleProvider);
    } else {
      await auth.currentUser!.linkWithProvider(appleProvider);
    }
  }

  Future<void> reauthenticateWithApple() async {
    final appleProvider = AppleAuthProvider();

    if (kIsWeb) {
      await auth.currentUser!.reauthenticateWithPopup(appleProvider);
    } else {
      await auth.currentUser!.reauthenticateWithProvider(appleProvider);
    }
  }
}
