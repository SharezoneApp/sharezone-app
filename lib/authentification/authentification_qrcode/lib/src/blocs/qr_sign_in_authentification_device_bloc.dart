// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/sharezone_app_functions.dart';
import 'package:authentification_qrcode/src/logic/qr_code_user_authenticator.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Hierüber meldet sich das Gerät des bereits zuvor authentifizierten Nutzers, damit dieser sich auf
/// einem neuen Gerät anmelden kann.
class QrSignInAuthentificationDeviceBloc extends BlocBase {
  final QrCodeUserAuthenticator qrSignInLogic;
  final String uID;

  QrSignInAuthentificationDeviceBloc._(this.qrSignInLogic, this.uID);

  factory QrSignInAuthentificationDeviceBloc({
    required FirebaseFirestore firestore,
    required SharezoneAppFunctions appFunctions,
    required String uID,
  }) {
    return QrSignInAuthentificationDeviceBloc._(
        QrCodeUserAuthenticator(firestore, appFunctions), uID);
  }

  Future<bool> authenticateUserViaQrCodeId(String qrID) {
    return qrSignInLogic.authenticateUserViaQrCodeId(qrId: qrID, uid: uID);
  }

  @override
  void dispose() {}
}
