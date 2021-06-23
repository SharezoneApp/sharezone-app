import 'package:app_functions/app_functions.dart';
import 'package:authentification_base/authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:meta/meta.dart';
import 'package:remote_configuration/remote_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharezone_common/references.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class BlocDependencies {
  final RemoteConfiguration remoteConfiguration;
  final FirebaseFirestore firestore;
  final References references;
  final FirebaseAuth auth;
  final KeyValueStore keyValueStore;
  final SharedPreferences sharedPreferences;
  final StreamingSharedPreferences streamingSharedPreferences;
  final RegistrationGateway registrationGateway;
  final FirebaseFunctions functions;
  final AppFunctions appFunctions;
  AuthUser authUser;

  BlocDependencies({
    @required this.sharedPreferences,
    this.authUser,
    @required this.keyValueStore,
    @required this.references,
    @required this.auth,
    @required this.firestore,
    @required this.streamingSharedPreferences,
    @required this.registrationGateway,
    @required this.appFunctions,
    @required this.functions,
    this.remoteConfiguration,
  });
}
