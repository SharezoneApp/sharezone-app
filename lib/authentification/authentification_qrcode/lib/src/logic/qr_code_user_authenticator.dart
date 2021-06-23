import 'package:app_functions/sharezone_app_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../models/qr_sign_in_document.dart';
import '../models/qr_sign_in_state.dart';

/// Logik für die Anmeldung eines WebGeräts über einen QrCode
/// Ein HostGerät ruft eine Server-Funktion auf, um dem Server sich als zugehörig zu der WebAnmeldung zu machen.
/// Der Server sendet anschließend verschlüsselt die Daten dafür an Firestore, worüber das Web-Gerät
/// diese auslesen kann.
/// Die Verschlüsselung erfolgt folgendermaßen:
/// Custom Token wird erstellt und mittels AES-CBC 256bit verschlüsselt.
/// AES Schlüssel wird anschließend RSA-OAEP verschlüsselt mit dem PublicKey der Webanwendung.
/// Dies ist ein 2048-bit PKCS8-public-pem Key.
/// Nur die Webanwendung kann daher den Token auslesen.
class QrCodeUserAuthenticator {
  final FirebaseFirestore firestore;
  final SharezoneAppFunctions appFunctions;
  CollectionReference get _qrSignInCollection =>
      firestore.collection('QrSignIn');

  const QrCodeUserAuthenticator(this.firestore, this.appFunctions);

  Stream<QrSignInState> streamQrSignInState(String qrId) {
    final query = _qrSignInCollection.doc(qrId).snapshots();
    return query.map((documentSnapshot) {
      if (documentSnapshot.exists) {
        final qrSignInDocument =
            QrSignInDocument.fromData(documentSnapshot.data());
        return qrSignInDocument.toSignInState();
      } else {
        return QrCodeIsGenerating();
      }
    });
  }

  /// erstellt das QR-Dokument in Firestore
  /// Dort sind vor allem die QrID und der PublicKey hinterlegt
  String generateQrId(String publicKey) {
    final qrId = _qrSignInCollection.doc().id;
    final qrSignInDocument = QrSignInDocument(
      qrId: qrId,
      publicKey: publicKey,
      created: DateTime.now(),
    );
    _qrSignInCollection.doc(qrId).set(qrSignInDocument.toData());
    return qrId;
  }

  Future<bool> authenticateUserViaQrCodeId(
      {@required String uid, @required String qrId}) async {
    final appFunctionResult =
        await appFunctions.authenticateUserViaQrCodeId(qrId: qrId, uid: uid);
    return appFunctionResult.hasData && appFunctionResult.data == true;
  }
}
