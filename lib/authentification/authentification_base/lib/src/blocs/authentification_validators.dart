// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:sharezone_localizations/sharezone_localizations.dart';

class AuthentificationValidationMessages {
  final String invalidEmail;
  final String invalidPassword;
  final String invalidName;

  const AuthentificationValidationMessages({
    required this.invalidEmail,
    required this.invalidPassword,
    required this.invalidName,
  });

  factory AuthentificationValidationMessages.fromL10n(
    SharezoneLocalizations l10n,
  ) {
    return AuthentificationValidationMessages(
      invalidEmail: l10n.authInvalidEmail,
      invalidPassword: l10n.authInvalidPassword,
      invalidName: l10n.authInvalidName,
    );
  }
}

mixin AuthentificationValidators {
  AuthentificationValidationMessages get validationMessages;
  static const int minNameSize = 2;
  static const int maxNameSize = 48;
  static RegExp charactersNotAllowedInNames = RegExp(
    r"^[^±!@£$%^&*_+§¡€#¢§¶•ªº«\\/<>?:;|=,]{1,48}$",
  );

  StreamTransformer<String, String> get validateEmail =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (email, sink) {
          if (isEmailValid(email)) {
            sink.add(email);
          } else {
            sink.addError(validationMessages.invalidEmail);
          }
        },
      );

  /// Eine valide E-Mail sollte ein "@" und ein "." enthalten,
  /// sowie keine deutschen Umlaute beinhalten.
  ///
  /// Es kam vor, dass Nutzer bei der Verknüpfung versehentlich ö anstatt
  /// o in der E-Mail angegeben haben. Da eine E-Mail Adresse sowieso
  /// niemals Deutsche Umlaute enthalten darf, können wir diese blocken.
  static bool isEmailValid(String email) {
    if (email.contains('@') &&
        email.contains('.') &&
        !email.contains(RegExp(r"[ä,ö,ü,ß]"))) {
      return true;
    }
    return false;
  }

  static bool isPasswordValid(String password) {
    if (password.length >= 8) {
      return true;
    }
    return false;
  }

  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // ATTENTION/ACHTUNG: Does NOT work properly! Use with caution!
  // Advice: Check in the end, when submitting a form if the passwords are REALLY
  // the same!
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  StreamTransformer<String?, String?> get validatePassword =>
      StreamTransformer<String?, String?>.fromHandlers(
        handleData: (password, sink) {
          if (password == null) {
            return;
          }

          if (isPasswordValid(password)) {
            sink.add(password);
          } else {
            sink.addError(validationMessages.invalidPassword);
          }
        },
      );

  StreamTransformer<String, String> get validateName =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (name, sink) {
          if (isNameValid(name)) {
            sink.add(name);
          } else {
            sink.addError(validationMessages.invalidName);
          }
        },
      );

  static bool isNameValid(String? name) {
    if (name == null) return false;
    return name.length >= minNameSize &&
        name.length <= maxNameSize &&
        name != "" &&
        charactersNotAllowedInNames.hasMatch(name);
  }
}
