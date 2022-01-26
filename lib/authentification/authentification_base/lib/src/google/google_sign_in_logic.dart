// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_utils/platform.dart';

const _desktopGoogleSignInClientID =
    '730263787697-c31kujlb53ajmm7jvuu2042t2m0nv5at';

class GoogleSignInLogic {
  final GoogleSignIn _googleSignIn;
  GoogleSignInLogic._(this._googleSignIn);

  factory GoogleSignInLogic() {
    final signIn = GoogleSignIn(
      signInOption: SignInOption.standard,
    );
    return GoogleSignInLogic._(signIn);
  }
  Future<bool> isSignedIn() async {
    return _googleSignIn.isSignedIn();
  }

  Future<AuthCredential> signIn() async {
    if (PlatformCheck.isDesktop) {
      await GoogleSignInDart.register(clientId: _desktopGoogleSignInClientID);
    }
    final googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount == null) {
      throw NoGoogleSignAccountSelected();
    }
    final gSA = await googleSignInAccount.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: gSA.accessToken, idToken: gSA.idToken);
    return credential;
  }

  Future<GoogleSignInAccount> signOut() async {
    return _googleSignIn.signOut();
  }
}
