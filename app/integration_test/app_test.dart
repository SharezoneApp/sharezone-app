// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:sharezone/keys.dart';
import 'package:sharezone/main/run_app.dart';
import 'package:sharezone/main/sharezone.dart';
import 'package:sharezone/util/flavor.dart';
import 'package:sharezone_utils/platform.dart';

void main() {
  patrolTest('sharezone e2e test',
      nativeAutomation: true,
      nativeAutomatorConfig: const NativeAutomatorConfig(
        packageName: 'de.codingbrain.sharezone',
        bundleId: 'de.codingbrain.sharezone.app',
      ), ($) async {
    isIntegrationTest = true;
    final dependencies = await initializeDependencies(flavor: Flavor.prod);

    const user1 = _UserCredentials(
      email: String.fromEnvironment('USER_1_EMAIL'),
      password: String.fromEnvironment('USER_1_PASSWORD'),
    );

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

    await $(K.emailTextField).enterText(user1.email);
    await $(K.passwordTextField).enterText(user1.password);
    await $(K.loginButton).tap();

    // At the moment, we can't log out properly / use the navigation when
    // signing in again. This blocks to write more integration tests. As a
    // workaround, we put all integration test into one test.
    //
    // We can remove this workaround, when the following issue are resolved:
    // * https://github.com/SharezoneApp/sharezone-app/issues/497
    // * https://github.com/SharezoneApp/sharezone-app/issues/117

    log("Test: User should be able to load groups");
    await $(K.groupsNavigationItem).tap();

    // We assume that the user is in at least 5 groups with the following
    // group names.
    expect($('10A'), findsOneWidget);
    expect($('Deutsch LK'), findsOneWidget);
    expect($('Englisch LK'), findsOneWidget);
    expect($('Französisch LK'), findsOneWidget);
    expect($('Latein LK'), findsOneWidget);
    expect($('Spanisch LK'), findsOneWidget);

    log("Test: User should be able to load timetable");
    await $(K.timetableNavigationItem).tap();

    // Ensure that the timetable is loaded. We assume that the timetable is
    // loaded when we found one of the courses.
    // await $('Deutsch LK').waitUntilVisible();
    await $('Deutsch LK').waitUntilExists();

    // We assume that we can load the timetable when we found x-times the name
    // of the course (the name of the course is included a lesson).
    expect($('Deutsch LK'), findsNWidgets(6));
    expect($('Englisch LK'), findsNWidgets(2));
    expect($('Französisch LK'), findsNWidgets(4));
    expect($('Latein LK'), findsNWidgets(4));
    expect($('Spanisch LK'), findsNWidgets(4));

    log("Test: User should be able to load information sheets");
    await $(K.blackboardNavigationItem).tap();

    // We a searching for an information sheet that is already created.
    expect($('German Course Trip to Berlin'), findsOneWidget);
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
