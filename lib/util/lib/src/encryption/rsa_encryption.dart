// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import "package:pointycastle/export.dart" as pointycastle;
import 'package:encrypt/encrypt.dart';
import 'package:util/src/encryption/rsa_pem.dart';

class RSAEncryptable {
  final pointycastle.RSAPublicKey _publicKey;
  final pointycastle.RSAPrivateKey? _privateKey;
  RSAEncryptable._(this._privateKey, this._publicKey);

  RSAEncryptable.fromPointCastleObjects(this._privateKey, this._publicKey);

  factory RSAEncryptable.fromPublicKey({required String publicKey}) {
    final parsedPublicKey = RSAKeyParser().parse(publicKey);
    return RSAEncryptable._(null, parsedPublicKey as pointycastle.RSAPublicKey);
  }

  factory RSAEncryptable(
      {required String publicKey, required String privateKey}) {
    final parsedPublicKey = RSAKeyParser().parse(publicKey);
    final parsedPrivateKey = RSAKeyParser().parse(privateKey);
    return RSAEncryptable._(
      parsedPrivateKey as pointycastle.RSAPrivateKey?,
      parsedPublicKey as pointycastle.RSAPublicKey,
    );
  }

  static Future<RSAEncryptable> generateFromRsaKeyGenerator() async {
    final generatedKeyPair = RSAKeyGenerator.generate();
    return RSAEncryptable._(
      generatedKeyPair.privateKey,
      generatedKeyPair.publicKey,
    );
  }

  Encrypter get _encrypter {
    return Encrypter(
      RSA(
        publicKey: _publicKey,
        privateKey: _privateKey,
        encoding: RSAEncoding.OAEP,
      ),
    );
  }

  getPrivateKeyPemString() {
    return RsaKeyHelper().encodePrivateKeyToPem(_privateKey!);
  }

  getPublicKeyPemString() {
    return RsaKeyHelper().encodePublicKeyToPem(_publicKey);
  }

  String decryptFromBase64(String base64) {
    return _encrypter.decrypt(Encrypted.fromBase64(base64));
  }

  String encryptToBase64(String value) {
    return _encrypter.encrypt(value).base64;
  }
}

class RSAKeyGenerator {
  final pointycastle.RSAPrivateKey privateKey;
  final pointycastle.RSAPublicKey publicKey;

  RSAKeyGenerator._(this.privateKey, this.publicKey);

  factory RSAKeyGenerator.generate() {
    final keyPair = RsaKeyHelper().generateKeyPair();
    return RSAKeyGenerator._(
      keyPair.privateKey as pointycastle.RSAPrivateKey,
      keyPair.publicKey as pointycastle.RSAPublicKey,
    );
  }
}
