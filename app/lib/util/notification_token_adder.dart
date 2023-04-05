// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:user/user.dart';

class NotificationTokenAdder {
  final NotificationTokenAdderApi _api;

  NotificationTokenAdder(this._api);

  Future<void> addTokenToUserIfNotExisting() async {
    List<String> existingTokens;
    final token = await _api.getFCMToken();
    if (token != null && token.isNotEmpty) {
      try {
        existingTokens = await _api.getUserTokensFromDatabase() ?? [];
      } on Exception {
        existingTokens = [];
      }
      if (!existingTokens.contains(token)) {
        await _api.tryAddTokenToDatabase(token);
        return;
      }
    }
    return;
  }
}

class NotificationTokenAdderApi {
  final UserGateway _userApi;
  final FirebaseMessaging _firebaseMessaging;

  NotificationTokenAdderApi(this._userApi, this._firebaseMessaging);

  Future<String> getFCMToken() {
    return _firebaseMessaging.getToken();
  }

  Future<void> tryAddTokenToDatabase(String token) async {
    try {
      await _userApi.addNotificationToken(token);
    } on Exception catch (e) {
      log("Could not add NotificationToken to User. Error: $e", error: e);
    }
    return;
  }

  Future<List<String>> getUserTokensFromDatabase() async {
    AppUser user = await _userApi.userStream.first;
    return user?.notificationTokens?.toList() ?? [];
  }
}
