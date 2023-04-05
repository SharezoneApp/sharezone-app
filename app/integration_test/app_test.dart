// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sharezone/main/run_app.dart';
import 'package:sharezone/main/sharezone.dart';
import 'package:sharezone/util/flavor.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  AppDependencies dependencies;
  _UserCredentials user1;

  setUpAll(() async {
    dependencies = await initializeDependencies(flavor: Flavor.dev);
  });

  setUp(() async {
    // Credentials are passed via environment variables. See "README.md" how to
    // pass the them correctly.
    user1 = _UserCredentials(
      email: const String.fromEnvironment('USER_1_EMAIL'),
      password: const String.fromEnvironment('USER_1_PASSWORD'),
    );

    // We should ensure that the user is logged out before running a test, to
    // have fresh start.
    await dependencies.blocDependencies.auth.signOut();
  });

  Future<void> _pumpSharezoneApp(WidgetTester tester) async {
    await tester.pumpWidget(
      Sharezone(
        beitrittsversuche: dependencies.beitrittsversuche,
        blocDependencies: dependencies.blocDependencies,
        dynamicLinkBloc: dependencies.dynamicLinkBloc,
      ),
    );
  }

  group('Authentication', () {
    testWidgets('User should be able to sign in', (tester) async {
      await _pumpSharezoneApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byKey(const Key('go-to-login-button-E2E')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('email-text-field-E2E')),
        user1.email,
      );
      await tester.enterText(
        find.byKey(const Key('password-text-field-E2E')),
        user1.password,
      );

      await tester.tap(find.byKey(const Key('login-button-E2E')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('dashboard-appbar-title-E2E')),
        findsOneWidget,
      );

      // At the moment, we can't log out properly / use the navigation when
      // signing in again. This blocks to write more integration tests. As a
      // workaround, we put all integration test into one test.
      //
      // We can remove this workaround, when the following issue are resolved:
      // * https://github.com/SharezoneApp/sharezone-app/issues/497
      // * https://github.com/SharezoneApp/sharezone-app/issues/117

      print("Test: User should be able to load groups");
      await tester.tap(find.byKey(const Key('nav-item-group-E2E')));
      await tester.pumpAndSettle();

      // We assume that the user is in at least 5 groups with the following
      // group names.
      expect(find.text('10A'), findsOneWidget);
      expect(find.text('Deutsch LK'), findsOneWidget);
      expect(find.text('Englisch LK'), findsOneWidget);
      expect(find.text('Französisch LK'), findsOneWidget);
      expect(find.text('Latein LK'), findsOneWidget);
      expect(find.text('Spanisch LK'), findsOneWidget);

      print("Test: User should be able to load timetable");
      await tester.tap(find.byKey(const Key('nav-item-timetable-E2E')));
      await tester.pumpAndSettle();

      // We assume that we can load the timetable when we found x-times the name
      // of the course (the name of the course is included a lesson).
      expect(find.text('Deutsch LK'), findsNWidgets(6));
      expect(find.text('Englisch LK'), findsNWidgets(2));
      expect(find.text('Französisch LK'), findsNWidgets(4));
      expect(find.text('Latein LK'), findsNWidgets(4));
      expect(find.text('Spanisch LK'), findsNWidgets(4));

      print("Test: User should be able to load information sheets");
      await tester.tap(find.byKey(const Key('nav-item-blackboard-E2E')));
      await tester.pumpAndSettle();

      // We a searching for an information sheet that is already created.
      const informationSheetTitel = 'German Course Trip to Berlin';
      expect(find.text(informationSheetTitel), findsOneWidget);

      // We don't check the text of the information sheet for now because the
      // `find.text()` can't find text `MarkdownBody` which it a bit more
      // complex.
    });
  });
}

/// The credentials for user used in the integration tests.
class _UserCredentials {
  const _UserCredentials({
    @required this.email,
    @required this.password,
  });

  /// The email address of the user.
  final String email;

  /// The password of the user.
  final String password;
}
