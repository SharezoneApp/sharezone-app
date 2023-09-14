// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part 'enter_activation_code_exception.dart';

class _EnterActivationCodeResultType {
  // Even "successfull" is a typo, it's the name of the event in the backend
  // and we can't change it.
  static const successful = 'successfull';
  static const notAvailable = 'notavailable';
  static const notFound = 'notfound';
  static const unknown = 'unknown';
}

abstract class EnterActivationCodeResult {
  factory EnterActivationCodeResult.fromData(Map<String, dynamic> data) {
    final resultType = data['resultType'];
    final resultData = data['resultData'];
    if (resultType == _EnterActivationCodeResultType.successful)
      return SuccessfulEnterActivationCodeResult.fromData(resultData);
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

class SuccessfulEnterActivationCodeResult implements EnterActivationCodeResult {
  final String codeName, codeDescription;

  const SuccessfulEnterActivationCodeResult(
    this.codeName,
    this.codeDescription,
  );

  factory SuccessfulEnterActivationCodeResult.fromData(dynamic resultData) {
    return SuccessfulEnterActivationCodeResult(
      resultData['name'] as String,
      resultData['description'] as String,
    );
  }
}
