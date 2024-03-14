// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_shared_implementation/feedback_shared_implementation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sharezone_console/firebase_options_prod.g.dart' as prod;
import 'package:sharezone_console/firebase_options_dev.g.dart' as dev;
import 'package:sharezone_console/flavor.dart';
import 'package:sharezone_console/login_signup_page.dart';
import 'package:sharezone_console/pages/feedbacks/feedbacks_page.dart';

import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final flavor = Flavor.fromEnvironment();
  await _initFirebase(flavor);

  runApp(MyApp());
}

Future<void> _initFirebase(Flavor flavor) async {
  await Firebase.initializeApp(
    options: switch (flavor) {
      Flavor.prod => prod.DefaultFirebaseOptions.currentPlatform,
      Flavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<SingleChildWidget> providers;

  @override
  void initState() {
    super.initState();

    final feedbackApi = FirebaseFeedbackApi(FirebaseFirestore.instance);
    providers = [
      Provider<FeedbackApi>.value(value: feedbackApi),
      Provider(
        create: (context) => FeedbackDetailsPageControllerFactory(
          feedbackApi: feedbackApi,
          userId: supportTeamUserId,
          crashAnalytics: null,
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sharezone Console',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StreamBuilder(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return LoginSignupPage(
                auth: auth,
              );
            }
          },
        ),
      ),
    );
  }
}
