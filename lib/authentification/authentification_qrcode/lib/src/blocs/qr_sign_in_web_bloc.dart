// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:app_functions/sharezone_app_functions.dart';
import 'package:authentification_base/authentification_analytics.dart';
import 'package:authentification_base/authentification_base.dart';
import 'package:authentification_qrcode/src/logic/qr_code_user_authenticator.dart';
import 'package:authentification_qrcode/src/models/qr_sign_in_state.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:platform_check/platform_check.dart';
import 'package:util/encryption.dart';
import 'package:fast_rsa/fast_rsa.dart' as fastrsa;

Future<RSAEncryptable> _getRSAEncryptable(dynamic value) async {
  return RSAEncryptable.generateFromRsaKeyGenerator();
}

Future<RSAEncryptable?> _getRSAEncryptableFromFastRsa() async {
  final keyPair = await fastrsa.RSA.generate(2048);
  return RsaKeyHelper().parsePrivateKey(keyPair.privateKey);
}

Future<RSAEncryptable?> _computeRSAEncryptable() {
  /// compute benötigt einen Parameter in der Future, daher wird value als null übergeben.
  if (PlatformCheck.isDesktopOrWeb) return _getRSAEncryptableFromFastRsa();
  return compute(_getRSAEncryptable, null);
}

class QrSignInWebBloc extends BlocBase {
  final LoginAnalytics loginAnalytics;
  final CrashAnalytics crashAnalytics;
  final QrCodeUserAuthenticator qrSignInLogic;
  final _qrSignInStateSubject =
      BehaviorSubject<QrSignInState>.seeded(QrCodeIsGenerating());
  RSAEncryptable? _rSAEncryptable;

  StreamSubscription? _qrIdStreamSubscription;

  QrSignInWebBloc._(
      this.qrSignInLogic, this.loginAnalytics, this.crashAnalytics) {
    _initializeAuthentification();
  }

  Future _initializeAuthentification() async {
    // Eine kleine Verzögerung, damit die Seite erstmal lädt und nicht stottert. Dies soll helfen.
    await Future.delayed(const Duration(milliseconds: 100));
    _rSAEncryptable = await _computeRSAEncryptable();
    final qrID =
        qrSignInLogic.generateQrId(_rSAEncryptable!.getPublicKeyPemString());
    _qrIdStreamSubscription =
        qrSignInLogic.streamQrSignInState(qrID).listen((onUpdate) async {
      if (onUpdate is QrSignInSuccessfull) {
        final customToken = _getCustomToken(onUpdate);
        _signInWithCustomToken(customToken);
      }
      try {
        if (_qrSignInStateSubject.isClosed) return;
        _qrSignInStateSubject.sink.add(onUpdate);
      } catch (e, s) {
        getCrashAnalytics().recordError(e, s);
      }
    });
  }

  Future<void> _signInWithCustomToken(String customToken) {
    final loginBloc = LoginBloc(loginAnalytics);
    return loginBloc.loginWithCustomTokenFromQrCodeSignIn(customToken);
  }

  factory QrSignInWebBloc({
    required FirebaseFirestore firestore,
    required SharezoneAppFunctions appFunctions,
    required LoginAnalytics loginAnalytics,
    required CrashAnalytics crashAnalytics,
  }) {
    return QrSignInWebBloc._(
      QrCodeUserAuthenticator(firestore, appFunctions),
      loginAnalytics,
      crashAnalytics,
    );
  }

  Stream<QrSignInState> get qrSignInState => _qrSignInStateSubject;

  String _getCustomToken(QrSignInSuccessfull qrSignInSuccessfull) {
    final aesKey = _rSAEncryptable!
        .decryptFromBase64(qrSignInSuccessfull.base64encryptedKey!);
    final aesEncryptable =
        AESEncryptable.fromKeyString(key: aesKey, iv: qrSignInSuccessfull.iv!);
    return aesEncryptable
        .decryptFromBase64(qrSignInSuccessfull.base64encryptedCustomToken!);
  }

  @override
  void dispose() {
    _qrSignInStateSubject.close();
    if (_qrIdStreamSubscription != null) _qrIdStreamSubscription!.cancel();
  }
}
