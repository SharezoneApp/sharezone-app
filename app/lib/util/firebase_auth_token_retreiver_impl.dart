import 'package:abgabe_client_lib/abgabe_client_lib.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthTokenRetreiverImpl extends FirebaseAuthTokenRetreiver {
  FirebaseAuthTokenRetreiverImpl(this._user);
  final User _user;

  @override
  Future<String> getToken() async {
    return await _user.getIdToken();
  }
}
