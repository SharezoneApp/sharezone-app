// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_qrcode/authentification_qrcode.dart';
import 'package:sharezone_common/helper_functions.dart';

class QrSignInDocument {
  final String? qrId;
  final String? publicKey;
  final String? encryptedCustomToken, encryptedKey, iv;
  final DateTime? created;

  const QrSignInDocument({
    this.qrId,
    this.publicKey,
    this.encryptedCustomToken,
    this.encryptedKey,
    this.iv,
    this.created,
  });

  factory QrSignInDocument.fromData(Map<String, dynamic> data) {
    return QrSignInDocument(
      qrId: data['qrId'],
      publicKey: data['publicKey'],
      encryptedCustomToken: data['encryptedCustomToken'],
      encryptedKey: data['encryptedKey'],
      iv: data['iv'],
      created: dateTimeFromTimestamp(data['created']),
    );
  }

  Map<String, dynamic> toData() {
    return {
      'qrId': qrId,
      'publicKey': publicKey,
      'created': timestampFromDateTime(created),
    };
  }

  QrSignInState toSignInState() {
    if (encryptedCustomToken == null) {
      return QrSignInIdle(qrId: qrId!);
    } else {
      return QrSignInSuccessfull(
        base64encryptedCustomToken: encryptedCustomToken,
        base64encryptedKey: encryptedKey,
        qrId: qrId,
        iv: iv,
      );
    }
  }
}
