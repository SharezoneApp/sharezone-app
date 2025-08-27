// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:analytics/analytics.dart';
import 'package:app_functions/app_functions.dart';
import 'package:authentification_base/authentification.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:platform_check/platform_check.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/dynamic_links/dynamic_link_bloc.dart';
import 'package:sharezone/dynamic_links/gruppen_beitritts_transformer.dart';
import 'package:sharezone/main/bloc_dependencies.dart';
import 'package:sharezone/main/ist_schon_gruppe_beigetreten.dart';
import 'package:sharezone/main/plugin_initializations.dart';
import 'package:sharezone/main/sharezone.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone/util/cache/key_value_store.dart';
import 'package:sharezone/util/flavor.dart';
import 'package:sharezone_common/firebase_dependencies.dart';
import 'package:sharezone_common/references.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../firebase_options_dev.g.dart' as fb_dev;
import '../firebase_options_prod.g.dart' as fb_prod;

BehaviorSubject<Beitrittsversuch?> runBeitrittsVersuche() {
  // ignore:close_sinks
  BehaviorSubject<Beitrittsversuch?> beitrittsversuche =
      BehaviorSubject<Beitrittsversuch?>();

  beitrittsversuche.listen(
    (beitrittsversuch) => log("Neuer beitrittsversuch: $beitrittsversuch"),
    onError:
        (e, s) => log(
          "Error beim Beitreten über Dynamic Link: $e $s",
          error: e,
          stackTrace: s,
        ),
    cancelOnError: false,
  );
  return beitrittsversuche;
}

DynamicLinkBloc runDynamicLinkBloc(
  PluginInitializations pluginInitializations,
) {
  final dynamicLinkBloc = DynamicLinkBloc(pluginInitializations.appLinks);
  dynamicLinkBloc.initialisere();

  dynamicLinkBloc.einkommendeLinks.listen(
    (einkommenderLink) => log("Neuer einkommender Link: $einkommenderLink"),
  );

  return dynamicLinkBloc;
}

Future<void> runFlutterApp({required Flavor flavor}) async {
  final dependencies = await initializeDependencies(flavor: flavor);
  runApp(
    Sharezone(
      beitrittsversuche: dependencies.beitrittsversuche,
      blocDependencies: dependencies.blocDependencies,
      dynamicLinkBloc: dependencies.dynamicLinkBloc,
      flavor: flavor,
    ),
  );

  if (PlatformCheck.isDesktopOrWeb) {
    // Required on web/desktop to automatically enable accessibility features,
    // see:
    // * https://github.com/flutter/flutter/issues/115158#issuecomment-1319080131
    // * https://github.com/gskinnerTeam/flutter-wonderous-app/issues/146
    //
    // Currently disabled because of:
    // https://github.com/flutter/flutter/issues/150020
    //
    // WidgetsFlutterBinding.ensureInitialized().ensureSemantics();
  }

  if (PlatformCheck.isWeb) {
    // This is intentionally not a debugPrint, as it's a message for users who
    // open the console on web.
    //
    // ignore: avoid_print
    print(
      '''Thanks for checking out Sharezone!
If you encounter any issues please report them at https://github.com/SharezoneApp/sharezone-app/issues.''',
    );
  }
}

Future<AppDependencies> initializeDependencies({required Flavor flavor}) async {
  // Damit die z.B. 'vor weniger als 1 Minute' Kommentar-Texte auch auf Deutsch
  // sein können
  timeago.setLocaleMessages('de', timeago.DeMessages());
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase(flavor);

  final pluginInitializations = await runPluginInitializations(flavor: flavor);

  final firebaseDependencies = FirebaseDependencies.get();
  final firebaseFunctions = FirebaseFunctions.instanceFor(
    region: 'europe-west1',
  );
  final appFunction = AppFunctions(firebaseFunctions);

  final references = References.init(
    firebaseDependencies: firebaseDependencies,
    appFunctions: appFunction,
  );
  final keyValueStore = FlutterKeyValueStore(
    pluginInitializations.sharedPreferences,
  );
  final registrationGateway = RegistrationGateway(
    references.users,
    firebaseDependencies.auth!,
  );
  final blocDependencies = BlocDependencies(
    analytics: Analytics(getBackend()),
    firestore: firebaseDependencies.firestore!,
    keyValueStore: keyValueStore,
    sharedPreferences: pluginInitializations.sharedPreferences,
    references: references,
    auth: firebaseDependencies.auth!,
    streamingSharedPreferences:
        pluginInitializations.streamingSharedPreferences,
    registrationGateway: registrationGateway,
    appFunctions: appFunction,
    remoteConfiguration: pluginInitializations.remoteConfiguration,
    functions: firebaseFunctions,
  );

  // `package:patrol` (e2e/integration tests) breaks when overriding onError, so
  // we disable the override if we are running these tests.
  if (!isIntegrationTest) {
    // From:
    // https://firebase.google.com/docs/crashlytics/get-started?platform=flutter#configure-crash-handlers
    FlutterError.onError =
        pluginInitializations.crashAnalytics.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      pluginInitializations.crashAnalytics.recordError(error, stack);
      return true;
    };
  }

  final dynamicLinkBloc = runDynamicLinkBloc(pluginInitializations);

  // ignore:close_sinks
  final beitrittsversuche = runBeitrittsVersuche();

  final analytics = Analytics(getBackend());

  UserGateway? userGateway;
  SharezoneGateway? sharezoneGateway;

  authUserStream.listen((currentUser) async {
    final isAuthenticated = currentUser?.uid != null;
    if (isAuthenticated) {
      // It's important to only create the gateway if it's null. If we would
      // create a new gateway every time the user signs in, we would create
      // multiple listeners for the same user. This would result in multiple
      // calls to the Firestore and would cause a memory leak (e.g. permission
      // denied error on sign out).
      sharezoneGateway ??= SharezoneGateway(
        authUser: currentUser!,
        memberID: currentUser.uid,
        references: references,
      );

      final gruppenBeitrittsTransformer = GruppenBeitrittsversuchFilterBloc(
        einkommendeLinks: dynamicLinkBloc.einkommendeLinks,
        istGruppeBereitsBeigetreten:
            (publicKey) async => await istSchonGruppeMitSharecodeBeigetreten(
              sharezoneGateway!,
              publicKey,
            ),
      );

      gruppenBeitrittsTransformer.gefilterteBeitrittsversuche.listen(
        beitrittsversuche.add,
        onError: beitrittsversuche.addError,
        cancelOnError: false,
      );

      userGateway ??= UserGateway(references, currentUser!);
      userGateway!.userStream.listen((user) {
        if (user?.typeOfUser != null) {
          analytics.setUserProperty(
            name: 'typeOfUser',
            value: user!.typeOfUser.name,
          );
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

      userGateway = null;
      sharezoneGateway = null;
    }
  });

  return AppDependencies(
    dynamicLinkBloc: dynamicLinkBloc,
    beitrittsversuche: beitrittsversuche,
    blocDependencies: blocDependencies,
    pluginInitializations: pluginInitializations,
  );
}

Future<void> _initializeFirebase(Flavor flavor) async {
  switch (flavor) {
    case Flavor.dev:
      await Firebase.initializeApp(
        options: fb_dev.DefaultFirebaseOptions.currentPlatform,
      );
      break;
    case Flavor.prod:
      await Firebase.initializeApp(
        options: fb_prod.DefaultFirebaseOptions.currentPlatform,
      );
  }
}

/// The dependencies for the [Sharezone] widget and the integration tests.
class AppDependencies {
  const AppDependencies({
    required this.dynamicLinkBloc,
    required this.beitrittsversuche,
    required this.blocDependencies,
    required this.pluginInitializations,
  });

  final DynamicLinkBloc dynamicLinkBloc;
  final Stream<Beitrittsversuch?> beitrittsversuche;
  final BlocDependencies blocDependencies;
  final PluginInitializations pluginInitializations;
}
