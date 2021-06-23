import 'package:firebase_auth/firebase_auth.dart';

abstract class UserGatewayAuthentifcation {
  Future<void> linkWithCredential(AuthCredential credential);
  Future<void> reloadFirebaseUser();
}
