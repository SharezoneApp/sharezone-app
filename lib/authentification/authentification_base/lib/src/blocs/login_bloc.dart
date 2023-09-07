// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:authentification_base/authentification_analytics.dart';
import 'package:authentification_base/authentification_google.dart';
import 'package:authentification_base/src/apple/apple_sign_in_logic.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/helper_functions.dart';

import 'authentification_validators.dart';

class LoginBloc extends BlocBase with AuthentificationValidators {
  final LoginAnalytics _analytics;

  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String?>();

  LoginBloc(this._analytics);

  Stream<String> get email => _emailSubject.stream.transform(validateEmail);
  Stream<String?> get password =>
      _passwordSubject.stream.transform(validatePassword);

  Function(String) get changeEmail => _emailSubject.sink.add;
  Function(String) get changePassword => _passwordSubject.sink.add;

  Stream<bool> get submitValid =>
      Rx.combineLatest2(email, password, (dynamic e, dynamic p) => true);

  Future<void> submit() async {
    if (!isEmptyOrNull(_emailSubject.valueOrNull)) {
      if (!isEmptyOrNull(_passwordSubject.valueOrNull)) {
        try {
          await submitValid.first;
        } catch (e) {
          throw IncorrectDataException();
        }
        final validEmail = _emailSubject.valueOrNull!;
        final validPassword = _passwordSubject.valueOrNull!;
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: validEmail, password: validPassword);
        _analytics.logEmailAndPasswordLogin();
        return;
      } else {
        _passwordSubject.sink.add("");
        throw PasswordIsMissingException();
      }
    } else {
      _emailSubject.sink.add("");
      throw EmailIsMissingException();
    }
  }

  Future<void> loginWithGoogle() async {
    final googleSignInLogic = GoogleSignInLogic();
    await googleSignInLogic.signIn();
    _analytics.logGoogleLogin();
  }

  Future<void> loginWithApple() async {
    final appleSignInLogic = AppleSignInLogic();
    await appleSignInLogic.signIn();
    _analytics.logAppleLogin();
  }

  Future<void> loginWithCustomTokenFromQrCodeSignIn(String customToken) async {
    _analytics.logQrCodeCustomTokenWebLogin();
    await FirebaseAuth.instance.signInWithCustomToken(customToken);
  }

  @override
  void dispose() {
    _emailSubject.close();
    _passwordSubject.close();
  }
}
