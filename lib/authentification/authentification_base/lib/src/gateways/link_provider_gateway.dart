// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification_analytics.dart';
import 'package:authentification_base/authentification_google.dart';
import 'package:authentification_base/src/apple/apple_sign_in_logic.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:analytics/analytics.dart';
import 'user_gateway_authentifcation.dart';

class LinkProviderGateway extends BlocBase {
  final UserGatewayAuthentifcation userGateway;
  final _analytics = LinkProviderAnalytics(Analytics(getBackend()));

  LinkProviderGateway(this.userGateway);

  Future<bool> linkUserWithGoogle() async {
    final credential = await _getGoogleCredential();
    await userGateway.linkWithCredential(credential);
    await _reloadFirebaseUser();

    _analytics.logGoogleLink();

    return true;
  }

  Future<bool> linkUserWithApple() async {
    final credential = await _getAppleCredential();
    await userGateway.linkWithCredential(credential);
    await _reloadFirebaseUser();

    _analytics.logAppleLink();

    return true;
  }

  Future<bool> linkUserWithEmailAndPassword(
      {@required String email, @required String password}) async {
    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    await userGateway.linkWithCredential(credential);
    await _reloadFirebaseUser();

    _analytics.logEmailAndPasswordLink();

    return true;
  }

  Future<AuthCredential> _getGoogleCredential() async {
    final googleSignInLogic = GoogleSignInLogic();
    return googleSignInLogic.signIn();
  }

  Future<AuthCredential> _getAppleCredential() async {
    final appleSignInLogic = AppleSignInLogic();
    return appleSignInLogic.getCredentials();
  }

  /// This method updates the local firebase user (for example
  /// the auth provider). If this functionen isn't called after
  /// linking a provider, the app thinks, that the user is still
  /// an anonymous user.
  Future<void> _reloadFirebaseUser() async =>
      await userGateway.reloadFirebaseUser();

  @override
  void dispose() {}
}
