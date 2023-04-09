// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

class AuthentificationValidators {
  static const int minNameSize = 2;
  static const int maxNameSize = 48;
  static RegExp charactersNotAllowedInNames =
      RegExp(r"^[^±!@£$%^&*_+§¡€#¢§¶•ªº«\\/<>?:;|=,]{1,48}$");

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (isEmailValid(email)) {
      sink.add(email);
    } else {
      sink.addError('Gib eine gültige E-Mail ein');
    }
  });

  /// Eine valide E-Mail sollte ein "@" und ein "." enthalten,
  /// sowie keine deutschen Umlaute beinhalten.
  ///
  /// Es kam vor, dass Nutzer bei der Verknüpfung versehentlich ö anstatt
  /// o in der E-Mail angegeben haben. Da eine E-Mail Adresse sowieso
  /// niemals Deutsche Umlaute enthalten darf, können wir diese blocken.
  static bool isEmailValid(String email) {
    if (email != null &&
        email.contains('@') &&
        email.contains('.') &&
        !email.contains(RegExp(r"[ä,ö,ü,ß]"))) {
      return true;
    }
    return false;
  }

  static bool isPasswordValid(String password) {
    if (password != null && password.length >= 8) {
      return true;
    }
    return false;
  }

  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // ATTENTION/ACHTUNG: Does NOT work properly! Use with caution!
  // Advice: Check in the end, when submitting a form if the passwords are REALLY
  // the same!
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password != null) {
      if (isPasswordValid(password)) {
        sink.add(password);
      } else {
        sink.addError('Ungültiges Passwort, bitte gib mehr als 8 Zeichen ein');
      }
    }
  });

  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (isNameValid(name)) {
      sink.add(name);
    } else {
      sink.addError("Ungültiger Name");
    }
  });

  static bool isNameValid(String name) {
    return name.length >= minNameSize &&
        name.length <= maxNameSize &&
        name != "" &&
        charactersNotAllowedInNames.hasMatch(name);
  }
}
