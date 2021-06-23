import 'package:meta/meta.dart';

abstract class QrSignInState {
  const QrSignInState();
}

class QrCodeIsGenerating extends QrSignInState {}

class QrSignInIdle extends QrSignInState {
  final String qrId;

  const QrSignInIdle({@required this.qrId});
}

class QrSignInSuccessfull extends QrSignInState {
  final String qrId;
  final String base64encryptedCustomToken;
  final String base64encryptedKey;
  final String iv;

  const QrSignInSuccessfull({
    @required this.base64encryptedCustomToken,
    @required this.qrId,
    @required this.base64encryptedKey,
    @required this.iv,
  });
}
