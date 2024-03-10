// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_console/firebase_options_prod.g.dart' as prod;
import 'package:sharezone_console/firebase_options_dev.g.dart' as dev;
import 'package:sharezone_console/flavor.dart';
import 'package:sharezone_console/login_signup_page.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return MaterialApp(
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
    );
  }
}
