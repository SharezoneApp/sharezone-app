import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDependencies {
  const FirebaseDependencies._({
    this.auth,
    this.firestore,
  });
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  factory FirebaseDependencies.get() {
    return FirebaseDependencies._(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    );
  }
}
