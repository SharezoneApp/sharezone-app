import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharezone/pages/settings/src/subpages/imprint/models/imprint.dart';

class ImprintGateway {
  final FirebaseFirestore _firestore;

  ImprintGateway(this._firestore);

  Stream<Imprint> get imprintStream => _firestore
      .collection('Legal')
      .doc('imprint')
      .snapshots()
      .map((doc) => Imprint.fromDocumentSnapshot(doc));
}
