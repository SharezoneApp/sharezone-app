// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:retry/retry.dart';

class StripeCheckoutSession {
  final String createCheckoutSessionFunctionUrl;
  final http.Client client;

  StripeCheckoutSession({
    required this.client,
    required this.createCheckoutSessionFunctionUrl,
  });

  /// Creates a new Stripe checkout session.
  ///
  /// Either [userId] or [buysFor] must be passed to identify the user. [userId]
  /// is the ID of the user who is buying the subscription. [buysFor] is the ID
  /// of the user for whom the subscription is bought and is used for the
  /// "Parents buy for their children" feature.
  ///
  /// Returns the URL of the Stripe checkout session. The user must be
  /// redirected to this URL to complete the payment.
  Future<String> create({
    String? userId,
    String? buysFor,
  }) async {
    assert(
      userId != null || buysFor != null,
      'Either userId or buysFor must be passed',
    );

    return retry<String>(
      () async {
        final response = await client.post(
          Uri.parse(createCheckoutSessionFunctionUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
            {
              if (userId != null) 'userId': userId,
              if (buysFor != null) 'buysFor': buysFor,
            },
          ),
        );

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          final String? url = responseData['url'];

          if (url == null) {
            throw Exception('Could not found url in response');
          }

          return url;
        } else {
          throw Exception(
            'Request failed with status: ${response.statusCode} (${response.body})',
          );
        }
      },
      maxAttempts: 3,
    );
  }
}
