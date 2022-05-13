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
import 'package:timeago/timeago.dart' as timeago;

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

/// Initializes the dependencies of the Flutter app.
///
/// Returns the initialized dependencies.
Future<AppDependencies> initializeDependencies({
  bool isIntegrationTest = false,
}) async {
  // Damit die z.B. 'vor weniger als 1 Minute' Kommentar-Texte auch auf Deutsch
  // sein können
  timeago.setLocaleMessages('de', timeago.DeMessages());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

  // Skipping the listeners to the auth state to make the integration tests
  // work.
  //
  // The code below that uses listenToAuthStateChanged creates SharezoneGateway
  // & UserGateway which automatically subscribes to document changes in several
  // collections in Firestore. This results in errors if the user logs out since
  // we don't correctly dispose or close the streams inside SharezoneGateway &
  // UserGateway. The errors will cause any integration test to automatically
  // fail.
  //
  // Currently we just work around that by not executing the code below at all
  // (and thus not creating SharezoneGateway). In the future we should ensure
  // that the SharezoneGateway does not unnecessarily subscribe to document
  // changes and that we can properly dispose of the subscriptions before
  // logging out. The listeners of "listenToAuthStateChanged().listen()" are not
  // disposed. Therefore, when signing out, the app still tries to stream the
  // Firestore documents which results into a
  // "[cloud_firestore/permission-denied] The caller does not have permission to
  // execute the specified operation." because the user isn't signed anymore.
  if (!isIntegrationTest) {
    listenToAuthStateChanged().listen((currentUser) {
      if (currentUser?.uid != null) {
        final sharezoneGateway = SharezoneGateway(
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

        UserGateway(references, currentUser).userStream.listen((user) {
          if (user?.typeOfUser != null) {
            analytics.setUserProperty(
                name: 'typeOfUser', value: enumToString(user.typeOfUser));
          }
        });
      }
    });
  }

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
