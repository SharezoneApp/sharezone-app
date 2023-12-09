// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sharezone/main/run_app.dart';
import 'package:sharezone/main/sharezone.dart';
import 'package:sharezone/util/flavor.dart';
import 'package:sharezone_utils/platform.dart';

/// Old integration tests that we keep for testing non-Android platforms.
///
/// We usually use `package:patrol` for our integration tests, but it we
/// couldn't set it up for iOS and web so far. Therefore, we use the old tests
/// as a fallback to at least have some integration tests for these platforms.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AppDependencies dependencies;
  late _UserCredentials user1;

  setUpAll(() async {
    dependencies = await initializeDependencies(flavor: Flavor.prod);
  });

  setUp(() async {
    // Credentials are passed via environment variables. See "README.md" how to
    // pass the them correctly.
    user1 = const _UserCredentials(
      email: String.fromEnvironment('USER_1_EMAIL'),
      password: String.fromEnvironment('USER_1_PASSWORD'),
    );

    // We should ensure that the user is logged out before running a test, to
    // have fresh start.
    await dependencies.blocDependencies.auth.signOut();
  });

  Future<void> pumpSharezoneApp(WidgetTester tester) async {
    await tester.pumpWidget(
      Sharezone(
        beitrittsversuche: dependencies.beitrittsversuche,
        blocDependencies: dependencies.blocDependencies,
        dynamicLinkBloc: dependencies.dynamicLinkBloc,
        flavor: Flavor.dev,
        isIntegrationTest: true,
      ),
    );
  }

  group('Authentication', () {
    testWidgets('User should be able to sign in', (tester) async {
      await pumpSharezoneApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // On web and desktop we don't show the welcome page, therefore we don't
      // need to navigate to the login page.
      if (!PlatformCheck.isDesktopOrWeb) {
        await tester.tap(find.byKey(const Key('go-to-login-button-E2E')));
        await tester.pumpAndSettle();
      }

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

      // Ensure that the user document is loaded. Otherwise, the user might see
      // for short a moment the page to select the type of user which could fail
      // the test.
      await tester
          .pumpUntil(find.byKey(const Key('dashboard-appbar-title-E2E')));

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

      log("Test: User should be able to load groups");
      await tester.tap(find.byKey(const Key('nav-item-group-E2E')));
      await tester.pumpAndSettle();

      // Ensure that the group list is loaded. When the school class is loaded,
      // we assume that the courses list is loaded as well.
      await tester.pumpUntil(find.text('Meine Klasse:'));

      // We assume that the user is in at least 5 groups with the following
      // group names.
      expect(find.text('10A'), findsOneWidget);
      expect(find.text('Deutsch LK'), findsOneWidget);
      expect(find.text('Englisch LK'), findsOneWidget);
      expect(find.text('Französisch LK'), findsOneWidget);
      expect(find.text('Latein LK'), findsOneWidget);
      expect(find.text('Spanisch LK'), findsOneWidget);

      log("Test: User should be able to load timetable");
      await tester.tap(find.byKey(const Key('nav-item-timetable-E2E')));
      await tester.pumpAndSettle();

      // Ensure that the timetable is loaded. We assume that the timetable is
      // loaded when we found one of the courses.
      await tester.pumpUntil(find.text('Deutsch LK'));

      // We assume that we can load the timetable when we found x-times the name
      // of the course (the name of the course is included a lesson).
      expect(find.text('Deutsch LK'), findsNWidgets(6));
      expect(find.text('Englisch LK'), findsNWidgets(2));
      expect(find.text('Französisch LK'), findsNWidgets(4));
      expect(find.text('Latein LK'), findsNWidgets(4));
      expect(find.text('Spanisch LK'), findsNWidgets(4));

      log("Test: User should be able to load information sheets");
      await tester.tap(find.byKey(const Key('nav-item-blackboard-E2E')));
      await tester.pumpAndSettle();

      // We a searching for an information sheet that is already created.
      const informationSheetTitel = 'German Course Trip to Berlin';
      await tester.pumpUntil(find.text(informationSheetTitel));
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
    required this.email,
    required this.password,
  });

  /// The email address of the user.
  final String email;

  /// The password of the user.
  final String password;
}

extension on WidgetTester {
  /// Waits for a widget identified by [finder] to be present in the widget
  /// tree.
  ///
  /// This function can be useful when there is no load indicator (if there
  /// were, `await tester.pumpAndSettle()` would wait until the load animation
  /// was finished) and the widget tree is not yet ready to be tested.
  ///
  /// The function repeatedly calls `tester.pump()` and then delays for
  /// a short duration, checking at each iteration if the widget identified by
  /// [finder] is present in the widget tree. This continues until the widget is
  /// found or the [timeout] duration has passed, whichever occurs first.
  ///
  /// Throws an [Exception] if the [timeout] duration passes without the widget
  /// being found in the widget tree.
  ///
  /// Workaround for https://github.com/flutter/flutter/issues/88765.
  ///
  /// ## Example
  ///
  /// ```dart
  /// await tester.pumpUntil(find.text('Hello, World'));
  /// ```
  Future<void> pumpUntil(
    Finder finder, {
    Duration timeout = const Duration(seconds: 70),
  }) async {
    final end = binding.clock.now().add(timeout);

    do {
      if (binding.clock.now().isAfter(end)) {
        throw Exception('Timed out waiting for $finder');
      }

      await pump();
      await Future.delayed(const Duration(milliseconds: 200));
    } while (finder.evaluate().isEmpty);
  }
}
