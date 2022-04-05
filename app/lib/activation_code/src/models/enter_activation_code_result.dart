// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part 'enter_activation_code_exception.dart';

class _EnterActivationCodeResultType {
  static const successfull = 'successfull';
  static const notavailable = 'notavailable';
  static const notfound = 'notfound';
  static const unknown = 'unknown';
}

abstract class EnterActivationCodeResult {
  factory EnterActivationCodeResult.fromData(Map<String, dynamic> data) {
    final resultType = data['resultType'];
    final resultData = data['resultData'];
    if (resultType == _EnterActivationCodeResultType.successfull)
      return SuccessfullEnterActivationCodeResult.fromData(resultData);
    else
      return FailedEnterActivationCodeResult.fromData(data);
  }
}

class FailedEnterActivationCodeResult implements EnterActivationCodeResult {
  final EnterActivationCodeException enterActivationCodeException;

  const FailedEnterActivationCodeResult(this.enterActivationCodeException);

  factory FailedEnterActivationCodeResult.fromData(Map<String, dynamic> data) {
    final resultType = data['resultType'] as String;
    return FailedEnterActivationCodeResult(
        EnterActivationCodeException.fromData(resultType));
  }
}

class NoDataEnterActivationCodeResult implements EnterActivationCodeResult {}

class LoadingEnterActivationCodeResult implements EnterActivationCodeResult {}

class SuccessfullEnterActivationCodeResult
    implements EnterActivationCodeResult {
  final String codeName, codeDescription;

  const SuccessfullEnterActivationCodeResult._(
      this.codeName, this.codeDescription);

  factory SuccessfullEnterActivationCodeResult.fromData(dynamic resultData) {
    return SuccessfullEnterActivationCodeResult._(
      resultData['name'] as String,
      resultData['description'] as String,
    );
  }
}
