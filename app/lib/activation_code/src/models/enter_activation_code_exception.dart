// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'enter_activation_code_result.dart';

abstract class EnterActivationCodeException {
  factory EnterActivationCodeException.fromData(String resultType) {
    if (resultType == _EnterActivationCodeResultType.notfound) {
      return NotFoundEnterActivationCodeException();
    } else if (resultType == _EnterActivationCodeResultType.notavailable) {
      return NotAvailableEnterActivationCodeException();
    } else if (resultType == _EnterActivationCodeResultType.unknown) {
      return UnknownEnterActivationCodeException();
    }
    return UnknownEnterActivationCodeException();
  }
}

class NotFoundEnterActivationCodeException
    implements EnterActivationCodeException {}

class NotAvailableEnterActivationCodeException
    implements EnterActivationCodeException {}

class NoInternetEnterActivationCodeException
    implements EnterActivationCodeException {}

class UnknownEnterActivationCodeException
    implements EnterActivationCodeException {
  final dynamic exception;

  UnknownEnterActivationCodeException({this.exception});
}
