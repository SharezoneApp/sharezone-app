// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:analytics/analytics.dart';
import 'package:app_functions/app_functions.dart';
import 'package:authentification_base/authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:key_value_store/key_value_store.dart';
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
  final Analytics analytics;

  AuthUser? authUser;

  BlocDependencies({
    required this.sharedPreferences,
    this.authUser,
    required this.keyValueStore,
    required this.references,
    required this.auth,
    required this.analytics,
    required this.firestore,
    required this.streamingSharedPreferences,
    required this.registrationGateway,
    required this.appFunctions,
    required this.functions,
    required this.remoteConfiguration,
  });
}
