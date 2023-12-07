// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:mockito/annotations.dart';
import 'package:stripe_checkout_session/stripe_checkout_session.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'stripe_checkout_session_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>(), MockSpec<http.Response>()])
void main() {
  group('StripeCheckoutSession', () {
    late MockClient client;
    late StripeCheckoutSession service;
    const testUrl = 'https://test.checkout.session';
    const functionsUrl = 'https://create-checkout.run.app';

    setUp(() {
      client = MockClient();
      service = StripeCheckoutSession(
        createCheckoutSessionFunctionUrl: functionsUrl,
        client: client,
      );
    });

    test('returns checkout url when passing user ID', () async {
      const userId = '123';
      when(
        client.post(
          Uri.parse(functionsUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: '{"userId":"$userId"}',
        ),
      ).thenAnswer((_) async => http.Response('{"url": "$testUrl"}', 200));

      final result = await service.create(userId: userId);

      expect(result, equals(testUrl));
    });

    test('returns checkout url when passing buysFor ID', () async {
      const buysFor = '456';
      when(
        client.post(
          Uri.parse(functionsUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: '{"buysFor":"$buysFor"}',
        ),
      ).thenAnswer((_) async => http.Response('{"url": "$testUrl"}', 200));

      final result = await service.create(buysFor: buysFor);

      expect(result, equals(testUrl));
    });
  });
}
