// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sharezone_common/api_errors.dart';

class GoogleSignInLogic {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth auth = FirebaseAuth.instance;

  GoogleSignInLogic._(this._googleSignIn);

  factory GoogleSignInLogic() {
    final signIn = GoogleSignIn();
    return GoogleSignInLogic._(signIn);
  }

  Future<AuthCredential> _getCredentials() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw NoGoogleSignAccountSelected();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  Future<void> signIn() async {
    await _ignoreCanceledException(() async {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        return FirebaseAuth.instance.signInWithPopup(googleProvider);
      }

      final googleCredential = await _getCredentials();
      return FirebaseAuth.instance.signInWithCredential(googleCredential);
    });
  }

  Future<UserCredential?> linkWithGoogle() async {
    return _ignoreCanceledException(() async {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        return auth.currentUser!.linkWithPopup(googleProvider);
      }

      final googleCredential = await _getCredentials();
      return auth.currentUser!.linkWithCredential(googleCredential);
    });
  }

  Future<void> reauthenticateWithGoogle() async {
    await _ignoreCanceledException(() async {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        return auth.currentUser!.reauthenticateWithPopup(googleProvider);
      }

      final googleCredential = await _getCredentials();
      return auth.currentUser!.reauthenticateWithCredential(googleCredential);
    });
  }

  Future<GoogleSignInAccount?> signOut() async {
    return _googleSignIn.signOut();
  }

  /// Ignores the [FirebaseAuthException] when the user cancels the sign in
  /// process.
  Future<UserCredential?> _ignoreCanceledException(
    Future<UserCredential> Function() function,
  ) async {
    try {
      return await function();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user') {
        return null;
      }

      rethrow;
    }
  }
}
