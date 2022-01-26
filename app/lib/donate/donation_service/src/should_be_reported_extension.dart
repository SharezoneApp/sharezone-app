// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
