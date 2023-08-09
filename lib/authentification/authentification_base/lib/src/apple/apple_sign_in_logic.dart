// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInLogic {
  /// Signs in with Apple. Returns the user if the sign in was successful.
  ///
  /// Returns null if the user cancels the sign in process.
  /// Throws an exception if the sign in fails.
  Future<User?> signIn() async {
    if (PlatformCheck.isMacOS || PlatformCheck.isIOS) {
      AuthorizationCredentialAppleID credentials;
      try {
        credentials = await SignInWithApple.getAppleIDCredential(
          scopes: [],
        );
      } on SignInWithAppleAuthorizationException catch (e) {
        if (e.code == AuthorizationErrorCode.canceled) return null;
        rethrow;
      }

      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: credentials.identityToken,
        accessToken: credentials.authorizationCode,
      );

      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return result.user;
    } else {
      return await FirebaseAuthOAuth()
          .openSignInFlow("apple.com", [], {"locale": "en"});
    }
  }

  Future<AuthCredential> getCredentials() async {
    assert(PlatformCheck.isMacOS ||
        PlatformCheck.isIOS ||
        PlatformCheck.isAndroid);
    final credentials = await SignInWithApple.getAppleIDCredential(
      scopes: [],
    );

    final oAuthProvider = OAuthProvider('apple.com');
    final credential = oAuthProvider.credential(
      idToken: credentials.identityToken,
      accessToken: credentials.authorizationCode,
    );

    return credential;
  }

  static Future<bool> isSignInGetCredentailsAvailable() async {
    if ((PlatformCheck.isIOS || PlatformCheck.isMacOS) &&
        await SignInWithApple.isAvailable()) return true;
    return false;
  }
}
