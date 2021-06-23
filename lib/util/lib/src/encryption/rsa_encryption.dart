import "package:pointycastle/export.dart" as pointycastle;
import 'package:encrypt/encrypt.dart';
import 'package:meta/meta.dart';
import 'package:util/src/encryption/rsa_pem.dart';

class RSAEncryptable {
  final pointycastle.RSAPublicKey _publicKey;
  final pointycastle.RSAPrivateKey _privateKey;
  RSAEncryptable._(this._privateKey, this._publicKey);

  RSAEncryptable.fromPointCastleObjects(this._privateKey, this._publicKey);

  factory RSAEncryptable.fromPublicKey({@required String publicKey}) {
    final parsedPublicKey = RSAKeyParser().parse(publicKey);
    return RSAEncryptable._(null, parsedPublicKey);
  }

  factory RSAEncryptable({String publicKey, String privateKey}) {
    final parsedPublicKey = RSAKeyParser().parse(publicKey);
    final parsedPrivateKey = RSAKeyParser().parse(privateKey);
    return RSAEncryptable._(parsedPrivateKey, parsedPublicKey);
  }

  static Future<RSAEncryptable> generateFromRsaKeyGenerator() async {
    final generatedKeyPair = RSAKeyGenerator.generate();
    return RSAEncryptable._(
      generatedKeyPair.privateKey,
      generatedKeyPair.publicKey,
    );
  }

  Encrypter get _encrypter {
    return Encrypter(RSA(
        publicKey: _publicKey,
        privateKey: _privateKey,
        encoding: RSAEncoding.OAEP));
  }

  getPrivateKeyPemString() {
    return RsaKeyHelper().encodePrivateKeyToPem(_privateKey);
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
    return RSAKeyGenerator._(keyPair.privateKey, keyPair.publicKey);
  }
}
