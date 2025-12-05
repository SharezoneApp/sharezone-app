// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DemoUser extends AuthUser {
  DemoUser() : super(uid: 'testUser', firebaseUser: DemoFirebaseUser());

  @override
  String get uid => "testUser";

  @override
  String get email => "test@sharezone.net";

  @override
  bool get isAnonymous => true;
}

class DemoFirebaseUser implements User {
  @override
  Future<void> delete() async {
    throw UnimplementedError();
  }

  @override
  String? get displayName => null;

  @override
  String? get email => null;

  @override
  bool get emailVerified => false;

  @override
  Future<String> getIdToken([bool forceRefresh = false]) {
    throw UnimplementedError();
  }

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) {
    throw UnimplementedError();
  }

  @override
  bool get isAnonymous => true;

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) {
    throw UnimplementedError();
  }

  @override
  Future<ConfirmationResult> linkWithPhoneNumber(
    String phoneNumber, [
    RecaptchaVerifier? verifier,
  ]) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> linkWithPopup(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<void> linkWithRedirect(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  UserMetadata get metadata => throw UnimplementedError();

  @override
  MultiFactor get multiFactor => throw UnimplementedError();

  @override
  String? get phoneNumber => null;

  @override
  String? get photoURL => null;

  @override
  List<UserInfo> get providerData => throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithCredential(
    AuthCredential credential,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> reauthenticateWithPopup(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> reauthenticateWithProvider(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<void> reauthenticateWithRedirect(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  String? get refreshToken => throw UnimplementedError();

  @override
  Future<void> reload() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) {
    throw UnimplementedError();
  }

  @override
  String? get tenantId => throw UnimplementedError();

  @override
  String get uid => throw UnimplementedError();

  @override
  Future<User> unlink(String providerId) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateDisplayName(String? displayName) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword(String newPassword) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePhotoURL(String? photoURL) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) {
    throw UnimplementedError();
  }

  @override
  Future<void> verifyBeforeUpdateEmail(
    String newEmail, [
    ActionCodeSettings? actionCodeSettings,
  ]) {
    throw UnimplementedError();
  }
}
