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
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_utils/platform.dart';

const _desktopGoogleSignInClientID =
    '730263787697-c31kujlb53ajmm7jvuu2042t2m0nv5at';

class GoogleSignInLogic {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth auth = FirebaseAuth.instance;

  GoogleSignInLogic._(this._googleSignIn);

  factory GoogleSignInLogic() {
    final signIn = GoogleSignIn();
    return GoogleSignInLogic._(signIn);
  }

  Future<bool> isSignedIn() async {
    return _googleSignIn.isSignedIn();
  }

  Future<AuthCredential> _getCredentials() async {
    if (PlatformCheck.isDesktop) {
      await GoogleSignInDart.register(clientId: _desktopGoogleSignInClientID);
    }

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
    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      await FirebaseAuth.instance.signInWithPopup(googleProvider);
      return;
    }

    final googleCredential = await _getCredentials();
    await FirebaseAuth.instance.signInWithCredential(googleCredential);
  }

  Future<void> linkWithGoogle() async {
    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      await auth.currentUser!.linkWithPopup(googleProvider);
      return;
    }

    final googleCredential = await _getCredentials();
    await auth.currentUser!.linkWithCredential(googleCredential);
  }

  Future<void> reauthenticateWithGoogle() async {
    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      await auth.currentUser!.reauthenticateWithPopup(googleProvider);
      return;
    }

    final googleCredential = await _getCredentials();
    await auth.currentUser!.reauthenticateWithCredential(googleCredential);
  }

  Future<GoogleSignInAccount?> signOut() async {
    return _googleSignIn.signOut();
  }
}
