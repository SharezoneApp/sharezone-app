import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter/services.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInLogic {
  Future<User> signIn() async {
    if (PlatformCheck.isMacOS || PlatformCheck.isIOS) {
      final credentials = await SignInWithApple.getAppleIDCredential(
        scopes: [],
      );
      if (credentials is AuthorizationCredentialAppleID) {
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: credentials.identityToken,
          accessToken: credentials.authorizationCode,
        );

        final result =
            await FirebaseAuth.instance.signInWithCredential(credential);
        return result.user;
      } else {
        throw PlatformException(
          code: 'ERROR_USERNAME_AND_PASSWORD_APPLE',
          message: "Username and Password Apple Sign is not implemented",
        );
      }
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

    if (credentials is AuthorizationCredentialAppleID) {
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: credentials.identityToken,
        accessToken: credentials.authorizationCode,
      );

      return credential;
    } else {
      throw PlatformException(
        code: 'ERROR_USERNAME_AND_PASSWORD_APPLE',
        message: "Username and Password Apple Sign is not implemented",
      );
    }
  }

  static Future<bool> isSignInGetCredentailsAvailable() async {
    if ((PlatformCheck.isIOS || PlatformCheck.isMacOS) &&
        await SignInWithApple.isAvailable()) return true;
    return false;
  }
}
