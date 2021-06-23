import 'package:encrypt/encrypt.dart';
import 'package:meta/meta.dart';

class AESEncryptable {
  final Key key;
  final IV iv;

  AESEncryptable._(this.key, this.iv);

  factory AESEncryptable.fromKeyString({
    @required String key,
    @required String iv,
  }) {
    return AESEncryptable._(Key.fromBase64(key), IV.fromBase64(iv));
  }

  Encrypter get _encrypter {
    return Encrypter(AES(key, mode: AESMode.cbc));
  }

  String decryptFromBase64(String base64) {
    return _encrypter.decrypt(Encrypted.fromBase64(base64), iv: iv);
  }

  String encryptToBase64(String value) {
    return _encrypter.encrypt(value).base64;
  }
}
