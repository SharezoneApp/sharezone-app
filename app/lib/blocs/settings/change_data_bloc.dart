// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:authentification_base/authentification.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/helper_functions.dart';
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
    } else
      return false;
  }

  bool compareEmail(String pEmail) {
    if (pEmail.toLowerCase() == _emailSubject.valueOrNull?.toLowerCase())
      return true;
    else
      return false;
  }

  Future<void> sendResetPasswordMail() async {
    if (await hasInternetAccess()) {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: userAPI.authUser!.email!);
    } else {
      throw NoInternetAccess();
    }
  }

  Future<void> submitEmail() async {
    final String currentEmail = userAPI.authUser!.email!;
    final String? newEmail = _emailSubject.valueOrNull;
    final String? password = _passwordSubject.valueOrNull;

    if (newEmail == currentEmail) {
      throw IdenticalEmailException(
          "Die eingegebene E-Mail ist doch identisch mit der alten?! 🙈",
          currentEmail);
    } else {
      if (!isEmptyOrNull(newEmail) &&
          AuthentificationValidators.isEmailValid(newEmail!)) {
        if (!isEmptyOrNull(password) &&
            AuthentificationValidators.isPasswordValid(password!)) {
          if (await hasInternetAccess()) {
            final credential = EmailAuthProvider.credential(
                email: currentEmail, password: password);
            await userAPI.authUser!.firebaseUser
                .reauthenticateWithCredential(credential);
            await userAPI.changeEmail(newEmail);

            firebaseAuth.signOut();
            firebaseAuth.signInWithEmailAndPassword(
                email: newEmail, password: password);
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

  Future<void> submitPassword() async {
    final String? password = _passwordSubject.valueOrNull;
    final String? newPassword = _newPasswordSubject.valueOrNull;
    final String email = userAPI.authUser!.email!;

    if (!isEmptyOrNull(password) &&
        AuthentificationValidators.isPasswordValid(password!)) {
      if (!isEmptyOrNull(newPassword) &&
          AuthentificationValidators.isPasswordValid(newPassword!)) {
        if (await hasInternetAccess()) {
          final AuthCredential credential =
              EmailAuthProvider.credential(email: email, password: password);
          await userAPI.authUser!.firebaseUser
              .reauthenticateWithCredential(credential);
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
  final String? message;
  final String? email;

  IdenticalEmailException([this.message, this.email]);

  @override
  String toString() {
    String message = "IdenticalEmailException";
    if (email != null || email != "") {
      message += ": $email is the same as before.";
    }
    return message;
  }
}

class NewPasswordIsMissingException implements Exception {
  @override
  String toString() {
    return "NewPasswordIsMissingException";
  }
}
