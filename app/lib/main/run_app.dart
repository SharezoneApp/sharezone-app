// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:analytics/analytics.dart';
import 'package:app_functions/app_functions.dart';
import 'package:authentification_base/authentification.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/blocs/bloc_dependencies.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/dynamic_links/dynamic_link_bloc.dart';
import 'package:sharezone/dynamic_links/gruppen_beitritts_transformer.dart';
import 'package:sharezone/main/flutter_error_handler.dart';
import 'package:sharezone/main/ist_schon_gruppe_beigetreten.dart';
import 'package:sharezone/main/plugin_initializations.dart';
import 'package:sharezone/main/sharezone.dart';
import 'package:sharezone/util/API.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone/util/cache/key_value_store.dart';
import 'package:sharezone_common/firebase_dependencies.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_common/references.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../firebase_options_dev.g.dart';

BehaviorSubject<Beitrittsversuch> runBeitrittsVersuche() {
  // ignore:close_sinks
  BehaviorSubject<Beitrittsversuch> beitrittsversuche =
      BehaviorSubject<Beitrittsversuch>();

  beitrittsversuche.listen(
    (beitrittsversuch) => print("Neuer beitrittsversuch: $beitrittsversuch"),
    onError: (e) => print("Error beim Beitreten über Dynamic Link: $e"),
    cancelOnError: false,
  );
  return beitrittsversuche;
}

DynamicLinkBloc runDynamicLinkBloc(
    PluginInitializations pluginInitializations) {
  final dynamicLinkBloc = DynamicLinkBloc(pluginInitializations.dynamicLinks);
  dynamicLinkBloc.initialisere();

  dynamicLinkBloc.einkommendeLinks.listen((einkommenderLink) =>
      print("Neuer einkommender Link: $einkommenderLink"));

  return dynamicLinkBloc;
}

Future<void> runFlutterApp() async {
  final dependencies = await initializeDependencies();

  runZonedGuarded<Future<void>>(
    () async => runApp(Sharezone(
      beitrittsversuche: dependencies.beitrittsversuche,
      blocDependencies: dependencies.blocDependencies,
      dynamicLinkBloc: dependencies.dynamicLinkBloc,
    )),
    (error, stackTrace) async {
      debugPrint(error.toString());

      // Whenever an error occurs, call the `reportCrash`
      // to send Dart errors to Crashlytics
      await dependencies.pluginInitializations.crashAnalytics.recordError(
        error,
        stackTrace,
      );
    },
  );
}

Future<AppDependencies> initializeDependencies() async {
  // Damit die z.B. 'vor weniger als 1 Minute' Kommentar-Texte auch auf Deutsch
  // sein können
  timeago.setLocaleMessages('de', timeago.DeMessages());
  WidgetsFlutterBinding.ensureInitialized();

  // On all platforms except the Web the FirebaseOptions are read from the
  // config files. We might update this in the future so that all platforms
  // have their FirebaseOptions read via DefaultFirebaseOptions.
  await Firebase.initializeApp(
      options:
          PlatformCheck.isWeb ? DefaultFirebaseOptions.currentPlatform : null);

  final pluginInitializations = await runPluginInitializations();

  final firebaseDependencies = FirebaseDependencies.get();
  final firebaseFunctions =
      FirebaseFunctions.instanceFor(region: 'europe-west1');
  final appFunction = AppFunctions(firebaseFunctions);

  final references = References.init(
    firebaseDependencies: firebaseDependencies,
    appFunctions: appFunction,
  );
  final keyValueStore =
      FlutterKeyValueStore(pluginInitializations.sharedPreferences);
  final registrationGateway =
      RegistrationGateway(references.users, firebaseDependencies.auth);
  final blocDependencies = BlocDependencies(
    analytics: Analytics(getBackend()),
    firestore: firebaseDependencies.firestore,
    keyValueStore: keyValueStore,
    sharedPreferences: pluginInitializations.sharedPreferences,
    references: references,
    auth: firebaseDependencies.auth,
    streamingSharedPreferences:
        pluginInitializations.streamingSharedPreferences,
    registrationGateway: registrationGateway,
    appFunctions: appFunction,
    remoteConfiguration: pluginInitializations.remoteConfiguration,
    functions: firebaseFunctions,
  );

  FlutterError.onError = (error) => flutterErrorHandler(error);

  final dynamicLinkBloc = runDynamicLinkBloc(pluginInitializations);

  // ignore:close_sinks
  final beitrittsversuche = runBeitrittsVersuche();

  final analytics = Analytics(getBackend());

  UserGateway userGateway;
  SharezoneGateway sharezoneGateway;
  listenToAuthStateChanged().listen((currentUser) async {
    final isAuthenticated = currentUser?.uid != null;
    if (isAuthenticated) {
      sharezoneGateway = SharezoneGateway(
          authUser: currentUser,
          memberID: currentUser.uid,
          references: references);

      final gruppenBeitrittsTransformer = GruppenBeitrittsversuchFilterBloc(
        einkommendeLinks: dynamicLinkBloc.einkommendeLinks,
        istGruppeBereitsBeigetreten: (publicKey) async =>
            await istSchonGruppeMitSharecodeBeigetreten(
          sharezoneGateway,
          publicKey,
        ),
      );

      gruppenBeitrittsTransformer.gefilterteBeitrittsversuche.listen(
        beitrittsversuche.add,
        onError: beitrittsversuche.addError,
        cancelOnError: false,
      );

      userGateway = UserGateway(references, currentUser);
      userGateway.userStream.listen((user) {
        if (user?.typeOfUser != null) {
          analytics.setUserProperty(
              name: 'typeOfUser', value: enumToString(user.typeOfUser));
        }
      });
    } else {
      // When the user signs out, we need to dispose the listeners and stream
      // subscriptions inside the gateways. Otherwise, we we would cause a
      // memory leak and receiving a permission denied error from Firestore
      // because we would try to access the user data after the user signed out.
      // This would result an instant fail of the integration tests.
      await userGateway?.dispose();
      await sharezoneGateway?.dispose();
    }
  });

  return AppDependencies(
    dynamicLinkBloc: dynamicLinkBloc,
    beitrittsversuche: beitrittsversuche,
    blocDependencies: blocDependencies,
    pluginInitializations: pluginInitializations,
  );
}

/// The dependencies for the [Sharezone] widget and the integration tests.
class AppDependencies {
  const AppDependencies({
    @required this.dynamicLinkBloc,
    @required this.beitrittsversuche,
    @required this.blocDependencies,
    @required this.pluginInitializations,
  });

  final DynamicLinkBloc dynamicLinkBloc;
  final Stream<Beitrittsversuch> beitrittsversuche;
  final BlocDependencies blocDependencies;
  final PluginInitializations pluginInitializations;
}
