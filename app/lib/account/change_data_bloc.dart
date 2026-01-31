// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:authentification_base/authentification.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:sharezone_utils/internet_access.dart';

class ChangeDataBloc extends BlocBase with AuthentificationValidators {
  final UserGateway userAPI;
  final FirebaseAuth firebaseAuth;

  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String?>();
  final _newPasswordSubject = BehaviorSubject<String?>();

  ChangeDataBloc({
    required this.userAPI,
    required this.firebaseAuth,
    required String? currentEmail,
  }) {
    if (currentEmail != null) {
      _emailSubject.sink.add(currentEmail);
    }
  }

  Stream<String> get email => _emailSubject.stream.transform(validateEmail);
  Stream<String?> get password =>
      _passwordSubject.stream.transform(validatePassword);
  Stream<String?> get newPassword =>
      _newPasswordSubject.stream.transform(validatePassword);

  Function(String) get changeEmail => _emailSubject.sink.add;
  Function(String?) get changePassword => _passwordSubject.sink.add;
  Function(String?) get changeNewPassword => _newPasswordSubject.sink.add;

  Stream<bool> get submitChangeEmailValid =>
      Rx.combineLatest2(email, password, (e, p) => true);
  Stream<bool> get submitChangePasswordValid =>
      Rx.combineLatest2(password, newPassword, (p, nP) => true);

  bool isPasswordEmpty() {
    if (_passwordSubject.valueOrNull == null ||
        _passwordSubject.valueOrNull!.isEmpty) {
      _passwordSubject.sink.add("");
      return true;
    } else {
      return false;
    }
  }

  bool compareEmail(String pEmail) {
    if (pEmail.toLowerCase() == _emailSubject.valueOrNull?.toLowerCase()) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendResetPasswordMail() async {
    if (await hasInternetAccess()) {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: userAPI.authUser!.email!,
      );
    } else {
      throw NoInternetAccess();
    }
  }

  Future<void> submitEmail() async {
    final String currentEmail = userAPI.authUser!.email!;
    final String? newEmail = _emailSubject.valueOrNull;
    final String? password = _passwordSubject.valueOrNull;

    if (newEmail == currentEmail) {
      throw const IdenticalEmailException();
    } else {
      if (!isEmptyOrNull(newEmail) &&
          AuthentificationValidators.isEmailValid(newEmail!)) {
        if (!isEmptyOrNull(password) &&
            AuthentificationValidators.isPasswordValid(password!)) {
          if (await hasInternetAccess()) {
            await _reauthenticateWithEmailAndPassword(currentEmail, password);
            await userAPI.verifyBeforeUpdateEmail(newEmail);
          } else {
            throw NoInternetAccess();
          }
        } else {
          if (password == null) {
            _passwordSubject.sink.add("");
          }
          throw PasswordIsMissingException();
        }
      } else {
        throw EmailIsMissingException();
      }
    }
    return;
  }

  Future<void> _reauthenticateWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await userAPI.authUser!.firebaseUser.reauthenticateWithCredential(
      credential,
    );
  }

  Future<void> signOutAndSignInWithNewCredentials() async {
    final newEmail = _emailSubject.value;
    final password = _passwordSubject.value;
    await firebaseAuth.signOut();

    if (password == null) {
      log('Could not reauthenticate as password was null.');
      return;
    }

    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: newEmail,
        password: password,
      );
    } catch (e) {
      // At this point, we can't show an error message to the user anymore
      // because the user is on the welcome screen (different MaterialApp).
      log('Could not reauthenticate with new credentials', error: e);
    }
  }

  Future<void> submitPassword() async {
    final String? password = _passwordSubject.valueOrNull;
    final String? newPassword = _newPasswordSubject.valueOrNull;
    final String email = userAPI.authUser!.email!;

    if (!isEmptyOrNull(password) &&
        AuthentificationValidators.isPasswordValid(password!)) {
      if (!isEmptyOrNull(newPassword) &&
          AuthentificationValidators.isPasswordValid(newPassword!)) {
        if (await hasInternetAccess()) {
          await _reauthenticateWithEmailAndPassword(email, password);
          userAPI.authUser!.firebaseUser.updatePassword(newPassword);
        } else {
          throw NoInternetAccess();
        }
      } else {
        if (newPassword == null) {
          _newPasswordSubject.sink.add("");
        }
        throw NewPasswordIsMissingException();
      }
    } else {
      if (password == null) {
        _passwordSubject.sink.add("");
      }
      throw PasswordIsMissingException();
    }
    return;
  }

  @override
  void dispose() {
    _emailSubject.close();
    _passwordSubject.close();
    _newPasswordSubject.close();
  }
}

class IdenticalEmailException implements Exception {
  const IdenticalEmailException();

  @override
  String toString() => "IdenticalEmailException";
}

class NewPasswordIsMissingException implements Exception {
  @override
  String toString() {
    return "NewPasswordIsMissingException";
  }
}
