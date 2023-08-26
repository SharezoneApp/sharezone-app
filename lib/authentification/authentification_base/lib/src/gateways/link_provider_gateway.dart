// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:authentification_base/authentification_analytics.dart';
import 'package:authentification_base/authentification_google.dart';
import 'package:authentification_base/src/apple/apple_sign_in_logic.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user_gateway_authentifcation.dart';

class LinkProviderGateway extends BlocBase {
  final UserGatewayAuthentifcation userGateway;

  final _analytics = LinkProviderAnalytics(Analytics(getBackend()));

  LinkProviderGateway(this.userGateway);

  Future<bool> linkUserWithGoogle() async {
    final userCredential = await GoogleSignInLogic().linkWithGoogle();
    if (userCredential == null) return false;

    _analytics.logGoogleLink();
    return true;
  }

  Future<bool> linkUserWithApple() async {
    final userCredential = await AppleSignInLogic().linkWithApple();
    if (userCredential == null) return false;

    _analytics.logAppleLink();
    return true;
  }

  Future<bool> linkUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    await userGateway.linkWithCredential(credential);

    // Even when we are using the `userChanges()` stream, we still need to call
    // `reload()` because the `isAnonymous` property is not updated on iOS (and
    // macOS). When the bug is fixed, we can remove this call.
    //
    // Bug report: https://github.com/firebase/flutterfire/issues/11520
    await userGateway.reloadUser();

    _analytics.logEmailAndPasswordLink();

    return true;
  }

  @override
  void dispose() {}
}
