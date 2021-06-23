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
    final resultType = data['resultType'];
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
        resultData['name'], resultData['description']);
  }
}
