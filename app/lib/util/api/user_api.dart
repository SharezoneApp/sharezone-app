// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:app_functions/app_functions.dart';
import 'package:authentification_base/authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/main/sharezone.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/references.dart';
import 'package:sharezone_utils/internet_access.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:user/user.dart';

class UserGateway implements UserGatewayAuthentifcation {
  final References references;
  final String uID;

  StreamSubscription<AppUser> _appUserSubscription;
  final _userSubject = BehaviorSubject<AppUser>();

  Stream<AppUser> get userStream => _userSubject;

  AppUser get data => _userSubject.valueOrNull;

  // Firebase User Stream
  final _authUserSubject = BehaviorSubject<AuthUser>();
  Stream<AuthUser> get authUserStream => _authUserSubject;
  AuthUser get authUser => _authUserSubject.value;

  Future<AppUser> get() {
    return references.users
        .doc(uID)
        .get()
        .then((snapshot) => AppUser.fromData(snapshot.data(), id: snapshot.id));
  }

  String getName() => _userSubject.valueOrNull.name;

  Stream<DocumentSnapshot> get userDocument =>
      references.users.doc(uID).snapshots();

  Stream<Provider> get providerStream =>
      _authUserSubject.map((user) => _getProvider(user.firebaseUser));

  UserGateway(this.references, AuthUser authUser) : uID = authUser.uid {
    _appUserSubscription =
        references.users.doc(uID).snapshots().map((documentSnapshot) {
      return AppUser.fromData(documentSnapshot.data(), id: uID);
    }).listen((newUser) {
      _userSubject.sink.add(newUser);
    });

    _authUserSubject.sink.add(authUser);
    _authUserSubject.sink.addStream(
      FirebaseAuth.instance.userChanges().map(AuthUser.fromFirebaseUser),
    );
  }

  Future<void> logOut() async {
    if (PlatformCheck.isMobile) {
      if (isIntegrationTest) {
        // Firebase Messaging is not available in integration tests.
        log('Skipping to remove Firebase Messaging token because integration test is running.');
        return;
      }
      removeNotificationToken(await FirebaseMessaging.instance.getToken());
    }
    authUser.signOut();
  }

  String getEmail() => authUser.email;
  bool isAnonymous() => authUser.isAnonymous;

  Stream<bool> isAnonymousStream() =>
      _authUserSubject.map((authUser) => authUser.isAnonymous);

  Provider _getProvider(User fbUser) {
    if (fbUser == null || fbUser.isAnonymous) {
      return Provider.anonymous;
    } else {
      if (fbUser.providerData.last.providerId == "google.com") {
        return Provider.google;
      }
      return Provider.email;
    }
  }

  /// Associates a user account from a third-party identity provider with this
  /// user and returns additional identity provider data.
  ///
  /// This allows the user to sign in to this account in the future with
  /// the given account.
  @override
  Future<User> linkWithCredential(AuthCredential credential) async {
    final authResult =
        await authUser.firebaseUser.linkWithCredential(credential);
    return authResult.user;
  }

  Future<void> changeState(StateEnum state) async {
    await references.users.doc(uID).update({"state": state.index});
  }

  Future<void> addNotificationToken(String token) async {
    await references.users.doc(uID).update({
      "notificationTokens": FieldValue.arrayUnion([token])
    });
  }

  void removeNotificationToken(String token) {
    references.users.doc(uID).update({
      "notificationTokens": FieldValue.arrayRemove([token])
    });
  }

  Future<void> setHomeworkReminderTime(TimeOfDay timeOfDay) async {
    await references.users.doc(uID).update(
        {"reminderTime": timeOfDay?.toApiString() ?? FieldValue.delete()});
  }

  Future<void> updateSettings(UserSettings userSettings) async {
    await references.users
        .doc(uID)
        .set({"settings": userSettings.toJson()}, SetOptions(merge: true));
  }

  Future<void> updateSettingsSingleFiled(String fieldName, dynamic data) async {
    await references.users.doc(uID).set({
      "settings": {fieldName: data},
    }, SetOptions(merge: true));
  }

  Future<void> updateUserTip(UserTipKey userTipKey, bool value) async {
    await references.users.doc(uID).set({
      "tips": {
        userTipKey.key: value,
      },
    }, SetOptions(merge: true));
  }

  void setBlackboardNotifications(bool enabled) {
    references.users.doc(uID).update({"blackboardNotifications": enabled});
  }

  void setCommentsNotifications(bool enabled) {
    references.users.doc(uID).update({"commentsNotifications": enabled});
  }

  Future<void> changeEmail(String email) async {
    await authUser.firebaseUser.updateEmail(email);
    return;
  }

  Future<void> addUser({@required AppUser user, bool merge = false}) async {
    assert(user != null);
    await references.users
        .doc(uID)
        .set(user.toCreateJson(), SetOptions(merge: true));

    return;
  }

  Future<bool> deleteUser(SharezoneGateway gateway) async {
    if (await hasInternetAccess()) {
      final currentUser = references.firebaseAuth.currentUser;
      return currentUser.delete().then((_) => true);
    } else {
      return Future.error(NoInternetAccess());
    }
  }

  Future<AppFunctionsResult<bool>> updateUser(AppUser userData) async {
    return references.functions
        .userUpdate(userID: userData.id, userData: userData.toEditJson());
  }

  Future<void> dispose() async {
    await Future.wait([
      _appUserSubscription.cancel(),
      _authUserSubject.close(),
      _userSubject.close(),
    ]);
  }
}

extension TimeOfDayToApiString on TimeOfDay {
  String toApiString() {
    final hour = _ifNecessaryAddZeroCharacter(this.hour);
    final minute = _ifNecessaryAddZeroCharacter(this.minute);

    return "$hour:$minute";
  }
}

String _ifNecessaryAddZeroCharacter(int timeUnit) {
  final stringVal = timeUnit.toString();
  if (timeUnit == 0) return "${stringVal}0";
  if (timeUnit > 0 && timeUnit < 10) return "0$stringVal";
  return stringVal;
}
