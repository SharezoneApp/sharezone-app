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

    return _ignoreCanceledException(() async {
      if (kIsWeb) {
        return auth.signInWithPopup(appleProvider);
      } else {
        return auth.signInWithProvider(appleProvider);
      }
    });
  }

  Future<UserCredential?> linkWithApple() async {
    final appleProvider = AppleAuthProvider();

    return _ignoreCanceledException(() async {
      if (kIsWeb) {
        return auth.currentUser!.linkWithPopup(appleProvider);
      } else {
        return auth.currentUser!.linkWithProvider(appleProvider);
      }
    });
  }

  Future<void> reauthenticateWithApple() async {
    final appleProvider = AppleAuthProvider();

    await _ignoreCanceledException(() async {
      if (kIsWeb) {
        return auth.currentUser!.reauthenticateWithPopup(appleProvider);
      } else {
        return auth.currentUser!.reauthenticateWithProvider(appleProvider);
      }
    });
  }

  /// Ignores the [FirebaseAuthException] when the user cancels the sign in
  /// process.
  Future<UserCredential?> _ignoreCanceledException(
    Future<UserCredential> Function() function,
  ) async {
    try {
      return await function();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user' || e.code == 'canceled') {
        return null;
      }

      rethrow;
    }
  }
}
