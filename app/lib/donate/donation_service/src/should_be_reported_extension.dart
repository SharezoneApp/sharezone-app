import 'package:purchases_flutter/errors.dart';

extension ShouldBeReportedExtension on PurchasesErrorCode {
  /// Diese Errors sollten niemals auftreten. Sollte es doch zu diesem Fall
  /// kommen, sollten diese Error an uns reported werden, damit diese behoben
  /// werden können.
  bool shouldErrorBeReported() {
    return [
      PurchasesErrorCode.unknownError,
      PurchasesErrorCode.unknownBackendError,
      PurchasesErrorCode.unexpectedBackendResponseError,
      PurchasesErrorCode.invalidCredentialsError,
      PurchasesErrorCode.invalidAppUserIdError,
      PurchasesErrorCode.invalidReceiptError,
      PurchasesErrorCode.receiptAlreadyInUseError,
    ].contains(this);
  }
}
