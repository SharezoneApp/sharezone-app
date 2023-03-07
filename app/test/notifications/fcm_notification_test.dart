// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:mockito/mockito.dart';
import 'package:sharezone/util/notification_token_adder.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNotificationTokenAdderApi extends Mock
    implements NotificationTokenAdderApi {}

void main() {
  NotificationTokenAdder notificationService;
  MockNotificationTokenAdderApi api;
  String testToken = "TOKEN";

  setUp(() {
    api = MockNotificationTokenAdderApi();
    notificationService = NotificationTokenAdder(api);
  });

  group('The token will not be added to the database if it is', () {
    test('null', () async {
      when(api.getFCMToken()).thenAnswer((_) => Future.value(null));

      await notificationService.addTokenToUserIfNotExisting();

      verifyNever(api.tryAddTokenToDatabase(any));
    });

    test('empty String', () async {
      when(api.getFCMToken()).thenAnswer((_) => Future.value(""));

      await notificationService.addTokenToUserIfNotExisting();

      verifyNever(api.tryAddTokenToDatabase(any));
    });
  });

  test(
      'If retrieved token from api is not in passed users tokens it will be added',
      () async {
    when(api.getFCMToken()).thenAnswer((_) => Future.value(testToken));

    await notificationService.addTokenToUserIfNotExisting();

    verify(api.tryAddTokenToDatabase(testToken)).called(1);
  });

  test(
      "If existing token is the same as the token from fcm then it will not be updated",
      () async {
    when(api.getUserTokensFromDatabase())
        .thenAnswer((_) => Future.value([testToken]));

    await notificationService.addTokenToUserIfNotExisting();

    verifyNever(api.tryAddTokenToDatabase(testToken));
  });

  test(
      'if token will still be added if api throws an error when loading tokens from database',
      () async {
    when(api.getUserTokensFromDatabase()).thenThrow(Exception("test"));
    when(api.getFCMToken()).thenAnswer((_) => Future.value(testToken));

    await notificationService.addTokenToUserIfNotExisting();

    verify(api.tryAddTokenToDatabase(testToken)).called(1);
  });
}
