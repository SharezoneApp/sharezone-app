import 'dart:math';

/// Der ID-Generator für Firestore-Dokumente, übernommen vom Cloud-Firestore
/// Client
class AutoIdGenerator {
  static const int _AUTO_ID_LENGTH = 20;

  static const String _AUTO_ID_ALPHABET =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  static final Random _random = Random();

  /// Automatically Generates a random new Id
  static String autoId() {
    final stringBuffer = StringBuffer();
    final maxRandom = _AUTO_ID_ALPHABET.length;

    for (var i = 0; i < _AUTO_ID_LENGTH; ++i) {
      stringBuffer.write(_AUTO_ID_ALPHABET[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }
}
