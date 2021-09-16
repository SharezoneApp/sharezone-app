import 'dart:async';

import 'package:analytics/analytics.dart';
import 'package:app_functions/app_functions.dart';
import 'package:authentification_base/authentification.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/blocs/bloc_dependencies.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/dynamic_links/dynamic_link_bloc.dart';
import 'package:sharezone/dynamic_links/gruppen_beitritts_transformer.dart';
import 'package:sharezone/main.dart';
import 'package:sharezone/main/dynamic_links.dart';
import 'package:sharezone/main/flutter_error_handler.dart';
import 'package:sharezone/main/ist_schon_gruppe_beigetreten.dart';
import 'package:sharezone/main/plugin_initializations.dart';
import 'package:sharezone/main/sharezone.dart';
import 'package:sharezone/util/API.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone/util/cache/key_value_store.dart';
import 'package:sharezone/widgets/animation/color_fade_in.dart';
import 'package:sharezone_common/firebase_dependencies.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_common/references.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/theme.dart';
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

Future runFlutterApp() async {
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

  // integration_test will not work if we override the FlutterError.onError
  // handler.
  // See: https://github.com/flutter/flutter/issues/34499
  if (!kIsDriverTest) {
    FlutterError.onError = (error) => flutterErrorHandler(error);
  }

  final dynamicLinkBloc = runDynamicLinkBloc(pluginInitializations);

  // ignore:close_sinks
  final beitrittsversuche = runBeitrittsVersuche();

  final analytics = Analytics(getBackend());

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
                sharezoneGateway, publicKey),
      );

      gruppenBeitrittsTransformer.gefilterteBeitrittsversuche.listen(
          beitrittsversuche.add,
          onError: beitrittsversuche.addError,
          cancelOnError: false);

      UserGateway(references, currentUser).userStream.listen((user) {
        if (user?.typeOfUser != null) {
          analytics.setUserProperty(
              name: 'typeOfUser', value: enumToString(user.typeOfUser));
        }
      });
    }
  });

  runZonedGuarded<Future<void>>(
    () async => runApp(
      OverlaySupport(
        child: DynamicLinkOverlay(
          einkommendeLinks: dynamicLinkBloc.einkommendeLinks,
          activated: false,
          child: ColorFadeIn(
            color: PlatformCheck.isWeb ? Colors.white : primaryColor,
            child: Sharezone(
              blocDependencies: blocDependencies,
              dynamicLinkBloc: dynamicLinkBloc,
              beitrittsversuche: beitrittsversuche,
            ),
          ),
        ),
      ),
    ),
    (error, strack) async {
      debugPrint(error.toString());

      // Whenever an error occurs, call the `reportCrash`
      // to send Dart errors to Crashlytics
      await pluginInitializations.crashAnalytics.recordError(error, strack);
    },
  );
}
