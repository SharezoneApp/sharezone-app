import 'dart:async';

import 'package:app_functions/app_functions.dart';
import 'package:authentification_base/authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/util/API.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/references.dart';
import 'package:sharezone_utils/internet_access.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:user/user.dart';

class UserGateway implements UserGatewayAuthentifcation {
  final References references;
  final String uID;

  final _streamSubscriptions = <StreamSubscription>[];
  final _userSubject = BehaviorSubject<AppUser>();

  Stream<AppUser> get userStream => _userSubject;

  AppUser get data => _userSubject.valueOrNull;

  // Auf Grund eines Fehlers im FirebaseAuth Plugin, wird bei der
  // reload() Methode nicht der firebaseUser sofort neu geladen.
  // So muss man diesen mit reload() neuladen und danach wieder
  // neu mit FirebaseAuth.instance.currentUser den neuen User ziehen.
  // Dieser neue Nutzer muss dann mit alten User überschrieben werden.
  // Damit dies möglich ist, darf der User nicht final sein.
  // Ticket: https://github.com/flutter/flutter/issues/20390
  AuthUser authUser;

  // Firebase User Stream
  final _authUserSubject = BehaviorSubject<AuthUser>();
  Stream<AuthUser> get authUserStream => _authUserSubject;

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

  UserGateway(this.references, this.authUser) : uID = authUser.uid {
    _streamSubscriptions
        .add(references.users.doc(uID).snapshots().map((documentSnapshot) {
      return AppUser.fromData(documentSnapshot.data(), id: uID);
    }).listen((newUser) {
      _userSubject.sink.add(newUser);
    }));
    _authUserSubject.sink.add(authUser);
  }

  Future<void> logOut() async {
    if (PlatformCheck.isMobile) {
      removeNotificationToken(await FirebaseMessaging.instance.getToken());
    }
    authUser.signOut();
  }

  String getEmail() => authUser.email;
  bool isAnonymous() => authUser.isAnonymous;
  Stream<bool> isAnonymousStream() =>
      _authUserSubject.map((authUser) => authUser.isAnonymous);

  /// Manually refreshes the data of the current user (for example,
  /// attached providers, display name, and so on).
  @override
  Future<void> reloadFirebaseUser() async {
    authUser.firebaseUser.reload();

    // Auf Grund Nutzer eines Fehlers im FirebaseAuth Plugin muss
    // nochmal neu geladen und gesetzt werden.
    // Ticket: https://github.com/flutter/flutter/issues/20390
    authUser = AuthUser.fromFirebaseUser(FirebaseAuth.instance.currentUser);
    _authUserSubject.sink.add(authUser);
  }

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
    await references.users.doc(authUser.uid).update({"state": state.index});
  }

  Future<void> addNotificationToken(String token) async {
    await references.users.doc(authUser.uid).update({
      "notificationTokens": FieldValue.arrayUnion([token])
    });
  }

  void removeNotificationToken(String token) {
    references.users.doc(authUser.uid).update({
      "notificationTokens": FieldValue.arrayRemove([token])
    });
  }

  Future<void> setHomeworkReminderTime(TimeOfDay timeOfDay) async {
    await references.users.doc(authUser.uid).update(
        {"reminderTime": timeOfDay?.toApiString() ?? FieldValue.delete()});
  }

  Future<void> updateSettings(UserSettings userSettings) async {
    await references.users
        .doc(authUser.uid)
        .set({"settings": userSettings.toJson()}, SetOptions(merge: true));
  }

  Future<void> updateSettingsSingleFiled(String fieldName, dynamic data) async {
    await references.users.doc(authUser.uid).set({
      "settings": {fieldName: data},
    }, SetOptions(merge: true));
  }

  Future<void> updateUserTip(UserTipKey userTipKey, bool value) async {
    await references.users.doc(authUser.uid).set({
      "tips": {
        userTipKey.key: value,
      },
    }, SetOptions(merge: true));
  }

  void setBlackboardNotifications(bool enabled) {
    references.users
        .doc(authUser.uid)
        .update({"blackboardNotifications": enabled});
  }

  void setCommentsNotifications(bool enabled) {
    references.users
        .doc(authUser.uid)
        .update({"commentsNotifications": enabled});
  }

  Future<void> changeEmail(String email) async {
    await authUser.firebaseUser.updateEmail(email);
    return;
  }

  Future<void> addUser({@required AppUser user, bool merge = false}) async {
    assert(user != null);
    await references.users
        .doc(authUser.uid)
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

  void dispose() {
    _streamSubscriptions.forEach((subscription) => subscription.cancel());
    _userSubject.close();
    _authUserSubject.close();
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
