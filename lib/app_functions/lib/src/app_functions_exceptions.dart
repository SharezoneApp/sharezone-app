// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

abstract class AppFunctionsException implements Exception {
  String get code;
  String get message;
}

class UnknownAppFunctionsException implements AppFunctionsException {
  final dynamic error;

  const UnknownAppFunctionsException(this.error);

  @override
  String get code => '000';

  @override
  String get message => 'UnknownException: $error';

  @override
  String toString() {
    return message;
  }
}

class TimeoutAppFunctionsException implements AppFunctionsException {
  @override
  String get code => '001';

  @override
  String get message => 'Timeout: Die CloudFunction hat zu lange gebraucht.';
}

class NoInternetAppFunctionsException implements AppFunctionsException {
  @override
  String get code => '002';

  @override
  String get message =>
      'NoInternet: Es konnte keine Internetverbindung hergestellt werden.';
}
