// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// Increasing the timeout in order to be able to run the tests on slower
// machines.
//
// The default timeout for integration tests is 12 minutes. But building the app
// with slower machines (e.g. GitHub Actions) takes more than 12 minutes (like
// 20 minutes). Therefore, the test times out even though the app isn't yet
// compiled.
@Timeout(Duration(minutes: 60))

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sharezone/main/run_app.dart';
import 'package:sharezone/main/sharezone.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  AppDependencies dependencies;
  _UserCredentials user1;

  setUpAll(() async {
    dependencies = await initializeDependencies();
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
