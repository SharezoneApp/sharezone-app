// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class BuyingEnabledApi {
  final http.Client _client;

  const BuyingEnabledApi({required http.Client client}) : _client = client;

  Future<BuyingFlag> isBuyingEnabled() async {
    final projectId = Firebase.app().options.projectId;

    return retry(() async {
      final response = await _client.get(
        Uri.parse(
          'https://europe-west1-$projectId.cloudfunctions.net/isBuyingEnabled',
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return BuyingFlag.values.tryByName(
          json['status'],
          defaultValue: BuyingFlag.unknown,
        );
      }

      return BuyingFlag.unknown;
    });
  }
}

enum BuyingFlag {
  /// Payment feature are enabled.
  enabled,

  /// Payment feature are disabled.
  disabled,

  /// The status could not be determined.
  ///
  /// In this case it's likely that either the client has no internet connection
  /// or our backend is down.
  unknown,
}
