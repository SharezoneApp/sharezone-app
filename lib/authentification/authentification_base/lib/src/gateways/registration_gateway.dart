// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:math';

import 'package:analytics/analytics.dart';
import 'package:authentification_base/authentification_analytics.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user/user.dart';

class RegistrationEvent {
  final String newUserId;

  RegistrationEvent({required this.newUserId});

  @override
  String toString() {
    return "RegistrationEvent(newUserId: $newUserId)";
  }
}

class RegistrationGateway extends BlocBase {
  final CollectionReference userCollection;
  final FirebaseAuth _auth;
  final RegistrationAnalytics _analytics;

  final _registrationEventController =
      StreamController<RegistrationEvent>.broadcast();
  Stream<RegistrationEvent> get registrationEvents =>
      _registrationEventController.stream;

  RegistrationGateway(
    this.userCollection,
    this._auth, {
    Analytics? analytics,
  }) : _analytics = RegistrationAnalyticsAnalyticsWithInternalFirebaseEvents(
          analytics ?? Analytics(getBackend()),
        );

  void _addUserToFirestore(AppUser user) {
    final data = user.toEditJson();
    data['legal'] = user.legalData;

    userCollection.doc(user.id).set(data, SetOptions(merge: true));
  }

  Future<AppUser> registerUser(TypeOfUser typeOfUser) async {
    User? fbUser = _auth.currentUser;
    bool anonymousLogin = false;

    if (fbUser == null) {
      fbUser = (await _auth.signInAnonymously()).user;
      anonymousLogin = true;
    }

    final userID = fbUser!.uid;

    final user = AppUser.create(id: userID).copyWith(
      name: fbUser.displayName ?? "Anonymer ${_getRandomAnimalName()}",
      typeOfUser: typeOfUser,
      state: StateEnum.notSelected,
      referralScore: 0,
      legalData: {
        'v2_0-legal-accepted': {
          "source": "registration",
          'deviceTime': clock.now(),
          'serverTime': FieldValue.serverTimestamp(),
        },
      },
    );

    _addUserToFirestore(user);
    anonymousLogin
        ? _analytics.logAnonymousRegistration()
        : _analytics.logOAuthRegistration();

    _publishRegistrationEvent(userID);

    return user;
  }

  Future<void> _publishRegistrationEvent(String uid) async {
    _registrationEventController.add(RegistrationEvent(newUserId: uid));
  }

  String _getRandomAnimalName() =>
      randomNames[Random().nextInt(randomNames.length)];

  @override
  void dispose() {}
}

const randomNames = <String>[
  "Löwe",
  "Tiger",
  "Vogel",
  "Pinguin",
  "Dalmatiner",
  "Gepard",
  "Lachs",
  "Elefant",
  "Affe",
  "Stier",
  "Gorilla",
  "Bär",
  "Eisbär",
  "Papagei",
  "Braunbär",
  "Wolf",
  "Schäferhund",
  "Kampfhund",
  "Dobermann",
  "Panda",
  "Wal",
  "Hai",
  "Pottwal",
  "Blauwal",
  "Buckelwal",
  "Riesenhai",
  "Fisch",
  "Aal",
  "Seelachs",
  "Hecht",
  "Zander",
  "Karpfen",
  "Krapfen",
  "Barsch",
  "Biber",
  "Fuchs",
  "Alligator",
  "Leopard",
  "Hamster",
];
