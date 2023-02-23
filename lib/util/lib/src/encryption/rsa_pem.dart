// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import "package:pointycastle/export.dart";
import "package:asn1lib/asn1lib.dart";
import 'package:rsa_pkcs/rsa_pkcs.dart' as pkcs;

import 'rsa_encryption.dart' as rsa_encryptable;

List<int> decodePEM(String pem) {
  var startsWith = [
    "-----BEGIN PUBLIC KEY-----",
    "-----BEGIN PRIVATE KEY-----",
    "-----BEGIN RSA PUBLIC KEY-----",
    "-----BEGIN RSA PRIVATE KEY-----",
    "-----BEGIN PGP PUBLIC KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
    "-----BEGIN PGP PRIVATE KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
  ];
  var endsWith = [
    "-----END PUBLIC KEY-----",
    "-----END PRIVATE KEY-----",
    "-----END RSA PUBLIC KEY-----",
    "-----END RSA PRIVATE KEY-----",
    "-----END PGP PUBLIC KEY BLOCK-----",
    "-----END PGP PRIVATE KEY BLOCK-----",
  ];
  bool isOpenPgp = pem.indexOf('BEGIN PGP') != -1;

  for (var s in startsWith) {
    if (pem.startsWith(s)) {
      pem = pem.substring(s.length);
    }
  }

  for (var s in endsWith) {
    if (pem.endsWith(s)) {
      pem = pem.substring(0, pem.length - s.length);
    }
  }

  if (isOpenPgp) {
    var index = pem.indexOf('\r\n');
    pem = pem.substring(0, index);
  }

  pem = pem.replaceAll('\n', '');
  pem = pem.replaceAll('\r', '');

  return base64.decode(pem);
}

class RsaKeyHelper {
  AsymmetricKeyPair<PublicKey, PrivateKey> generateKeyPair() {
    var keyParams =
        new RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 12);

    var secureRandom = new FortunaRandom();
    var random = new Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(new KeyParameter(new Uint8List.fromList(seeds)));

    var rngParams = new ParametersWithRandom(keyParams, secureRandom);
    var k = new RSAKeyGenerator();
    k.init(rngParams);

    return k.generateKeyPair();
  }

  String encrypt(String plaintext, RSAPublicKey publicKey) {
    var cipher = new RSAEngine()
      ..init(true, new PublicKeyParameter<RSAPublicKey>(publicKey));
    var cipherText =
        cipher.process(new Uint8List.fromList(plaintext.codeUnits));

    return new String.fromCharCodes(cipherText);
  }

  String decrypt(String ciphertext, RSAPrivateKey privateKey) {
    var cipher = new RSAEngine()
      ..init(false, new PrivateKeyParameter<RSAPrivateKey>(privateKey));
    var decrypted =
        cipher.process(new Uint8List.fromList(ciphertext.codeUnits));

    return new String.fromCharCodes(decrypted);
  }

  parsePrivateKey(String privateKey) {
    final parser = pkcs.RSAPKCSParser();
    final parserResult = parser.parsePEM(privateKey);
    final private = parserResult.private!;
    /*
    print("modulus: ${private.modulus}");
    print("publicExponent: ${private.publicExponent}");
    print("privateExponent: ${private.privateExponent}");
    print("exponent1: ${private.exponent1}");
    print("exponent2: ${private.exponent2}");
    print("Prime1: ${private.prime1}");
    print("Prime2: ${private.prime2}");
    print("coefficient: ${private.coefficient}");
    */

    final privateKeyObject = RSAPrivateKey(
      private.modulus,
      private.privateExponent,
      private.prime1,
      private.prime2,
    );
    final publicKeyObject = RSAPublicKey(
      private.modulus,
      BigInt.from(private.publicExponent),
    );
    return rsa_encryptable.RSAEncryptable.fromPointCastleObjects(
        privateKeyObject, publicKeyObject);
  }

  parsePublicKeyFromPem(pemString) {
    List<int> publicKeyDER = decodePEM(pemString);
    var asn1Parser = new ASN1Parser(publicKeyDER as Uint8List);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var publicKeyBitString = topLevelSeq.elements[1];

    var publicKeyAsn = new ASN1Parser(publicKeyBitString.contentBytes()!);
    ASN1Sequence publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
    var modulus = publicKeySeq.elements[0] as ASN1Integer;
    var exponent = publicKeySeq.elements[1] as ASN1Integer;

    RSAPublicKey rsaPublicKey =
        RSAPublicKey(modulus.valueAsBigInteger!, exponent.valueAsBigInteger!);

    return rsaPublicKey;
  }

  parsePrivateKeyFromPem(pemString) {
    List<int> privateKeyDER = decodePEM(pemString);
    var asn1Parser = new ASN1Parser(privateKeyDER as Uint8List);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    // var version = topLevelSeq.elements[0];
    // var algorithm = topLevelSeq.elements[1];
    var privateKey = topLevelSeq.elements[2];

    asn1Parser = new ASN1Parser(privateKey.contentBytes()!);
    var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    // version = pkSeq.elements[0];
    var modulus = pkSeq.elements[1] as ASN1Integer;
    // var publicExponent = pkSeq.elements[2] as ASN1Integer;
    var privateExponent = pkSeq.elements[3] as ASN1Integer;
    var p = pkSeq.elements[4] as ASN1Integer;
    var q = pkSeq.elements[5] as ASN1Integer;
    // var exp1 = pkSeq.elements[6] as ASN1Integer;
    // var exp2 = pkSeq.elements[7] as ASN1Integer;
    // var co = pkSeq.elements[8] as ASN1Integer;

    RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
        modulus.valueAsBigInteger!,
        privateExponent.valueAsBigInteger!,
        p.valueAsBigInteger,
        q.valueAsBigInteger);

    return rsaPrivateKey;
  }

  encodePublicKeyToPem(RSAPublicKey publicKey) {
    var algorithmSeq = new ASN1Sequence();
    var algorithmAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList(
        [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj =
        new ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    var publicKeySeq = new ASN1Sequence();
    publicKeySeq.add(ASN1Integer(publicKey.modulus!));
    publicKeySeq.add(ASN1Integer(publicKey.exponent!));
    var publicKeySeqBitString =
        new ASN1BitString(Uint8List.fromList(publicKeySeq.encodedBytes));

    var topLevelSeq = new ASN1Sequence();
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqBitString);
    var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

    return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
  }

  encodePrivateKeyToPem(RSAPrivateKey privateKey) {
    var version = ASN1Integer(BigInt.from(0));

    var algorithmSeq = new ASN1Sequence();
    var algorithmAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList(
        [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj =
        new ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    var privateKeySeq = new ASN1Sequence();
    var modulus = ASN1Integer(privateKey.n!);
    var publicExponent = ASN1Integer(BigInt.parse('65537'));
    var privateExponent = ASN1Integer(privateKey.privateExponent!);
    var p = ASN1Integer(privateKey.p!);
    var q = ASN1Integer(privateKey.q!);
    var dP = privateKey.privateExponent! % (privateKey.p! - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ = privateKey.privateExponent! % (privateKey.q! - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = privateKey.q!.modInverse(privateKey.p!);
    var co = ASN1Integer(iQ);

    privateKeySeq.add(version);
    privateKeySeq.add(modulus);
    privateKeySeq.add(publicExponent);
    privateKeySeq.add(privateExponent);
    privateKeySeq.add(p);
    privateKeySeq.add(q);
    privateKeySeq.add(exp1);
    privateKeySeq.add(exp2);
    privateKeySeq.add(co);
    var publicKeySeqOctetString =
        new ASN1OctetString(Uint8List.fromList(privateKeySeq.encodedBytes));

    var topLevelSeq = new ASN1Sequence();
    topLevelSeq.add(version);
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqOctetString);
    var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

    return """-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----""";
  }
}
