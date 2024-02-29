import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class BuyingFlagApi {
  final http.Client _client;

  const BuyingFlagApi({
    required http.Client client,
  }) : _client = client;

  Future<BuyingFlag> isBuyingEnabled() async {
    final projectId = Firebase.app().options.projectId;

    return retry(() async {
      final response = await _client.get(Uri.parse(
          'https://europe-west1-$projectId.cloudfunctions.net/isBuyingEnabled'));

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
