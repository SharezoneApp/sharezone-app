// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:sharezone/keys.dart';
import 'package:sharezone/main/run_app.dart';
import 'package:sharezone/main/sharezone.dart';
import 'package:sharezone/util/flavor.dart';
import 'package:sharezone_utils/platform.dart';

void main() {
  const config = PatrolTesterConfig(
    existsTimeout: Duration(seconds: 30),
    visibleTimeout: Duration(seconds: 30),
    settleTimeout: Duration(seconds: 30),
  );
  group('e2e tests', () {
    late AppDependencies dependencies;
    late _UserCredentials credentials;

    setUp(() async {
      isIntegrationTest = true;
      dependencies = await initializeDependencies(flavor: Flavor.prod);

      credentials = const _UserCredentials(
        email: String.fromEnvironment('USER_1_EMAIL'),
        password: String.fromEnvironment('USER_1_PASSWORD'),
      );
    });

    Future<void> login(PatrolIntegrationTester $) async {
      await $.pumpWidgetAndSettle(Sharezone(
        beitrittsversuche: dependencies.beitrittsversuche,
        blocDependencies: dependencies.blocDependencies,
        dynamicLinkBloc: dependencies.dynamicLinkBloc,
        flavor: Flavor.dev,
        isIntegrationTest: true,
      ));

      // On web and desktop we don't show the welcome page, therefore we don't
      // need to navigate to the login page.
      if (!PlatformCheck.isDesktopOrWeb) {
        await $(K.goToLoginButton).tap();
      }

      await $(K.emailTextField).enterText(credentials.email);
      await $(K.passwordTextField).enterText(credentials.password);
      await $(K.loginButton).tap();
    }

    patrolTest('can log in', config: config, ($) async {
      await login($);
    });

    patrolTest('User should be able to load groups', config: config, ($) async {
      await login($);
      await $(K.groupsNavigationItem).tap();

      await $('Meine Klasse:').waitUntilExists();

      // We assume that the user is in at least 5 groups with the following
      // group names.
      expect($('10A'), findsOneWidget);
      expect($('Deutsch LK'), findsOneWidget);
      expect($('Englisch LK'), findsOneWidget);
      expect($('Französisch LK'), findsOneWidget);
      expect($('Latein LK'), findsOneWidget);
      expect($('Spanisch LK'), findsOneWidget);
    });

    patrolTest('User should be able to load timetable', config: config,
        ($) async {
      await login($);
      await $(K.timetableNavigationItem).tap();

      await $('Deutsch LK').waitUntilExists();
      // We assume that we can load the timetable when we found x-times the name
      // of the course (the name of the course is included a lesson).
      expect($('Deutsch LK'), findsNWidgets(6));
      expect($('Englisch LK'), findsNWidgets(2));
      expect($('Französisch LK'), findsNWidgets(4));
      expect($('Latein LK'), findsNWidgets(4));
      expect($('Spanisch LK'), findsNWidgets(4));
    });

    patrolTest('User should be able to load information sheets', config: config,
        ($) async {
      await login($);
      await $(K.blackboardNavigationItem).tap();

      await $('German Course Trip to Berlin').waitUntilExists();

      // We a searching for an information sheet that is already created.
      expect($('German Course Trip to Berlin'), findsOneWidget);
    });
  });
}

/// The credentials for user used in the integration tests.
class _UserCredentials {
  const _UserCredentials({
    required this.email,
    required this.password,
  });

  /// The email address of the user.
  final String email;

  /// The password of the user.
  final String password;
}
