// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2


abstract class QrSignInState {
  const QrSignInState();
}

class QrCodeIsGenerating extends QrSignInState {}

class QrSignInIdle extends QrSignInState {
  final String? qrId;

  const QrSignInIdle({required this.qrId});
}

class QrSignInSuccessfull extends QrSignInState {
  final String? qrId;
  final String? base64encryptedCustomToken;
  final String? base64encryptedKey;
  final String? iv;

  const QrSignInSuccessfull({
    required this.base64encryptedCustomToken,
    required this.qrId,
    required this.base64encryptedKey,
    required this.iv,
  });
}
