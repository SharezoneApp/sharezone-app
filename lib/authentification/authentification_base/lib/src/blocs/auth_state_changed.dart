import 'package:authentification_base/src/models/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

Stream<AuthUser> listenToAuthStateChanged() {
  return FirebaseAuth.instance
      .authStateChanges()
      .map((firebaseUser) => AuthUser.fromFirebaseUser(firebaseUser));
}
